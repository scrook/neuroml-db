import pydevd
pydevd.settrace('10.211.55.3', port=4200, stdoutToServer=True, stderrToServer=True)

db_server = "spike.asu.edu"
db_name = "neuroml_dev"
#model_csv_file = "ChannelsReformat.csv"
#model_csv_file = "ChannelsReformatConcModel.csv"
model_csv_file = "Traub2005_NT.csv"

import MySQLdb
import splinter
import logging
from collections import namedtuple
from string import Template
import csv
import sys

try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

class BatchNeuroML:  
    
    input_csv = []
      
    # ---------------------------- Named Tuples --------------------------------
    
    InputLine = namedtuple('InputLine','modelType modelName fileName children references neurolexTerm neurolexURI keywords pubmedID translator authors') # give header names here
    MetadataRange = namedtuple('MetadataRange', 'start end')
    PublicationMetadataID = namedtuple('PublicationMetadataID','pubID authorListID')
    PubmedTitleAuthors = namedtuple('PubmedTitleAuthors','title authors')
    Author = namedtuple('Author', 'last first') 
    
    #---------------------------  Dictionaries --------------------------------
    metadata_ranges = {"AuthorList":  MetadataRange(start=1000000L,end=1999999L),
                       "People":      MetadataRange(start=2000000L,end=2999999L),
                       "NeuroLex":    MetadataRange(start=3000000L,end=3999999L),
                       "Keywords":    MetadataRange(start=4000000L,end=4999999L),
                       "Refer":       MetadataRange(start=5000000L,end=5999999L),
                       "Publication": MetadataRange(start=6000000L,end=6999999L)}   
    next_metadata_ID = {}       # same key as metadata_ranges to give next available Metadata_ID/Person_ID in range
    next_NML_model_ID = {}      # TT: int  - for each model type (CH, CL, NT, SY)
    pubmed_title_author = {}    # PubmedID: PubmedTitleAuthors(title: str, authors: [Author(last: str, first: str) ...])
    publication_metadata = {}   # PubmedID: PublicationMetadataID(pubID: long, authorListID: long)
    people_metadata = {}        # Person_ID: Author(last: str, first: str)
    resource_metadata = {}      # Initialize with Resource_Name: Resource_ID in database (assume there else ERROR)
    author_translator = {"author": '0',
                         "translator": '1',
                         "both": '2'}
    #------------------------ DATABASE QUERIES ------------------------------------
        
    # query_authorList_ID returns AuthorList_ID associated with a Publication_ID
    # NOTE: If translators are the same, this should return only 1 AuthorList_ID
    query_authorList_ID = """SELECT a.Metadata_ID 
                           FROM  model_metadata_associations a
                           WHERE a.Metadata_ID < 2000000 and
                                 a.Model_ID in (SELECT p.Model_ID
                                                FROM model_metadata_associations p
                                                WHERE p.Metadata_ID = %s);"""
    
    query_model_by_filename = 'SELECT Model_ID FROM all_models_view WHERE Model_File LIKE "%%%s" ORDER BY upload_time DESC'
    
    query_next_metadata = "SELECT Metadata_ID FROM metadatas WHERE Metadata_ID BETWEEN %s and %s order by Metadata_ID desc LIMIT 1;"
    query_next_person_ID = "SELECT Person_ID FROM people WHERE Person_ID BETWEEN %s and %s order by Person_ID desc LIMIT 1;"
    query_next_NML = "SELECT Model_ID FROM models WHERE Model_ID LIKE %s order by Model_ID desc LIMIT 1;"

    query_person_ID =  """SELECT p.Person_ID 
                        FROM people p 
                        WHERE p.Person_Last_Name = %s and p.Person_First_Name LIKE %s
                        ORDER BY p.Person_ID;"""

    query_neurolex_uri = "SELECT NeuroLex_ID FROM neurolexes WHERE NeuroLex_URI = %s LIMIT 1"

    query_pub_ID = "SELECT Publication_ID FROM publications WHERE Pubmed_Ref = %s"
    
    query_resources = "SELECT Resource_ID, Name from resources"
    
    #------------------------ DATABASE INSERT TEMPLATES ------------------------------------
 
    insert_models_template = Template("INSERT into models(Model_ID) values ('$id')")  
    # referential integrity from type table to models 
    insert_cells_template = Template("INSERT into cells(Cell_ID, Cell_Name, MorphML_File, Upload_Time, Comments) values ('$id','$name','/var/www/NeuroMLmodels/$id/$fname',NOW(),'')")
    insert_channels_template = Template("INSERT into channels(Channel_ID, Channel_Name, ChannelML_File, Upload_Time, Comments) values ('$id','$name','/var/www/NeuroMLmodels/$id/$fname',NOW(),'')")
    insert_networks_template = Template("INSERT into networks(Network_ID, Network_Name, NetworkML_File, Upload_Time, Comments) values ('$id','$name','/var/www/NeuroMLmodels/$id/$fname',NOW(),'')")
    insert_synapses_template = Template("INSERT into synapses(Synapse_ID, Synapse_Name, Synapse_File, Upload_Time, Comments) values ('$id','$name','/var/www/NeuroMLmodels/$id/$fname',NOW(),'')")
    insert_concentrations_template = Template("INSERT into concentrations(Concentration_ID, Concentration_Name, Concentration_File, Upload_Time, Comments) values ('$id','$name','/var/www/NeuroMLmodels/$id/$fname',NOW(),'')")


    insert_type_template = {'CH': insert_channels_template,
                            'CL': insert_cells_template,
                            'NT': insert_networks_template,
                            'SY': insert_synapses_template,
                            'CN': insert_concentrations_template}
    
    insert_metadatas_template = Template("INSERT into metadatas(Metadata_ID) values ($metaid)")
    # referential integrity from specific metadata table to metadatas     
    insert_authorList_template = Template("INSERT into author_lists(AuthorList_ID) values ($metaid)")
    insert_author_list_association_template = Template("INSERT into author_list_associations(AuthorList_ID, Person_ID, author_sequence, is_translator, Comments) values ($alid, $pid, $seq,'$aort', '')")
    insert_keyword_template = Template("INSERT into other_keywords(Other_Keyword_ID, Other_Keyword_Term, Comments) values ($metaid, '$keywords', '') " )
    insert_keyword_template = Template("INSERT into other_keywords(Other_Keyword_ID, Other_Keyword_Term, Comments) values ($metaid, '$keywords', '') " )
    insert_neurolex_template = Template("INSERT into neurolexes(NeuroLex_ID, NeuroLex_URI, NeuroLex_Term, Comments) values ($metaid, '$uri', '$term', '')")
    insert_people_template = Template("INSERT into people(Person_ID, Person_First_Name, Person_Middle_Name, Person_Last_Name, Institution, Email, Comments) values($metaid, '$first', null, '$last', null, null, '')")
    insert_pub_template = Template("INSERT into publications(Publication_ID, Pubmed_Ref, Full_Title, Comments) values ($metaid, 'pubmed/$ref', '$title', '')")
    insert_refer_template = Template("INSERT into refers(Reference_ID, Reference_Resource_ID, Reference_URI, Comments) values ($metaid, $resourceid,'$uri', '')")
    
    insert_model_metadata_associations_template = Template("INSERT into model_metadata_associations(Metadata_ID, Model_ID, Comments) values ($metaid,'$modelid', '') ")
    
    insert_cell_channel_template = Template("INSERT into cell_channel_associations(Cell_ID, Channel_ID, Comments) values ('$parent', '$child', '')")
    insert_cell_synapse_template = Template("INSERT into cell_synapse_associations(Cell_ID, Synapse_ID, Comments) values ('$parent', '$child', '')")
    insert_cell_concentration_template = Template("INSERT into cell_concentration_associations(Cell_ID, Concentration_ID, Comments) values ('$parent', '$child', '')")
    insert_network_cell_template = Template("INSERT into network_cell_associations(Network_ID, Cell_ID, Comments) values ('$parent', '$child', '')")
    insert_network_synapse_template = Template("INSERT into network_synapse_associations(Network_ID, Synapse_ID, Comments) values ('$parent', '$child', '')")
    insert_network_concentration_template = Template("INSERT into network_concentration_associations(Network_ID, Concentration_ID, Comments) values ('$parent', '$child', '')")

    insert_child_template = {'CLCH': insert_cell_channel_template,
                             'CLSY': insert_cell_synapse_template,
                             'CLCN': insert_cell_concentration_template,
                             'NTCL': insert_network_cell_template,
                             'NTSY': insert_network_synapse_template,
                             'NTCN': insert_network_concentration_template}
    
    cp_template = Template("cp $fname /var/www/NeuroMLmodels/$id/")
    #---------------------------- UTILITIES ----------------------------------------
    
    def initialize_nexts(self):
        for model_type in ['CN', 'CH', 'CL', 'NT', 'SY']:
            self.dbCursor.execute(self.query_next_NML, ('NML' + model_type+'%%',))
            m_result = self.dbCursor.fetchone()
            self.next_NML_model_ID[model_type] = 1 if m_result is None else long(m_result[0][-6:]) + 1
            logging.info("next NML " + model_type + " : " + str(self.next_NML_model_ID[model_type]))
            
        for k in self.metadata_ranges.keys():
            if (k != "People"):
                self.dbCursor.execute(self.query_next_metadata, (self.metadata_ranges.get(k).start, self.metadata_ranges.get(k).end))
                k_result = self.dbCursor.fetchone()
                self.next_metadata_ID[k] = k_result[0] + 1
            else:
                self.dbCursor.execute(self.query_next_person_ID, (self.metadata_ranges.get(k).start, self.metadata_ranges.get(k).end))
                k_result = self.dbCursor.fetchone()
                self.next_metadata_ID[k] = k_result[0] + 1
            logging.info("next_metadata " + k + " : " + str(self.next_metadata_ID[k]))
    
    def initialize_resources(self):
        self.dbCursor.execute(self.query_resources)
        r_result = self.dbCursor.fetchall()
        for r in r_result:
            self.resource_metadata[r[1]] = r[0]
    
    def load_csv(self, fName):
        with open(fName,'rb') as f:
            rdr = csv.reader(f, dialect='excel')
            rdr.next()  # skip header row
            for originalLine in rdr:
                lineList = [] 
                for i in range(11): # 0-10 fields
                    if originalLine[i] == '' or originalLine[i].lower() == 'none':
                        lineList.append(None)
                    else:
                        lineList.append(originalLine[i])

                line = tuple(lineList)
                self.input_csv.append(self.InputLine(line[0],line[1],line[2],line[3],line[4],line[5],line[6],line[7],line[8], line[9], line[10]))

    #--------------------------  AuthorList and Pubmed  Preprocessing ------------------------------------------       
    def find_authorList_MetadataID(self, pub_metadata_ID):    
        authorList_metadata_ID = 0
        try:
            self.dbCursor.execute(self.query_authorList_ID, (pub_metadata_ID,))
            al_result = self.dbCursor.fetchone()
            if (al_result is not None):
                authorList_metadata_ID = al_result[0]
                # Assumption: Only one author list (meaning a model would not be in database for same pub with different translators) 
        except Exception as e:
            logging.error('AuthorList database query: ' + str(e))
        return authorList_metadata_ID
    
    def find_pubmed_in_db(self, pmid):        
        pub_metadata_ID = 0
        try:
            self.dbCursor.execute(self.query_pub_ID, (('pubmed/'+str(pmid)),))
            pm_result = self.dbCursor.fetchone()
            if (pm_result is not None):
                pub_metadata_ID = pm_result[0]
        except Exception as e:
            logging.error('Pubmed database query: ' + str(e))
        return pub_metadata_ID
    
    def find_pubmed_info(self, browser, pmid):        
                browser.visit('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&id='+pmid)
        
        pm_Element = ET.XML(browser.html.encode('utf-8'))
        pm_Tree = ET.ElementTree(pm_Element)
        title = pm_Tree.findall('.//ArticleTitle')[0].text
        
        author_list = pm_Tree.findall('.//Author')
        authors = [self.Author(last=author.find('LastName').text, first=author.find('ForeName').text)
                   for author in author_list]
        return self.PubmedTitleAuthors(title, authors)
    
    def process_pubmed(self, pmid_list):
        browser = None
        
        for pmid in pmid_list:
            pub_metadata_ID = self.find_pubmed_in_db(pmid)
            if (pub_metadata_ID==0):
                if not browser:
                    browser = splinter.Browser()
                self.pubmed_title_author[pmid] = self.find_pubmed_info(browser, pmid)
            elif (pub_metadata_ID >= self.metadata_ranges["Publication"].start):
                authorList_metadata_ID = self.find_authorList_MetadataID(pub_metadata_ID)
                self.publication_metadata[pmid] = self.PublicationMetadataID(pub_metadata_ID, authorList_metadata_ID)
            else:
                logging.error('Publication ID wrong range')

        if browser:
            browser.quit()
    
    #---------------------------- Process Input Line ------------------------------
    # InputLine = namedtuple('InputLine','modelType modelName fileName children references neurolexTerm neurolexURI keywords pubmedID translator authors')     
    def add_person_to_author_list(self, out, person_ID, authorList_ID, author_translator, author_sequence):
        insert_al_association = self.insert_author_list_association_template.substitute(alid=authorList_ID,pid=person_ID,seq=author_sequence,aort=author_translator)
        logging.info(insert_al_association)
        out.write(insert_al_association + ';\n')
   
    def check_person_in_db(self, out, author):
        try:
            # try to match on last name and first name
            self.dbCursor.execute(self.query_person_ID, (author.last.encode('utf8'),author.first.encode('utf8')+'%%'))
            if (self.dbCursor.rowcount == 1):
                person_result = self.dbCursor.fetchone()
                person_ID = person_result[0]
            else:
                # try to match on first initial
                self.dbCursor.execute(self.query_person_ID, (author.last.encode('utf8'), author.first[:1]+'%%'))
                if (self.dbCursor.rowcount == 0):
                    person_ID = self.next_metadata_ID['People']
                    self.next_metadata_ID['People'] += 1
                    insert_people = self.insert_people_template.substitute(metaid=person_ID,first=author.first.split(' ',1)[0],last=author.last.encode('utf8'))
                    logging.info(insert_people.decode('utf8'))
                    out.write(insert_people + ';\n')
                else:
                    person_result = self.dbCursor.fetchone()
                    person_ID = person_result[0]
                    if (self.dbCursor.rowcount > 1):
                        logging.info("NOTE: More than one person with same last name and first initial in DB: " + author.last + ", " + author.first[:1])             
        except Exception as e:
            logging.error('PersonID database query: ' + str(e))
        self.people_metadata[person_ID] = author
        return person_ID
    
    def process_person(self, out, author_or_translator):
        person_ID = 0
        # match on last name and first initial
        pid_list = [pid for (pid, au) in self.people_metadata.items() 
                            if au.last == author_or_translator.last and au.first[:1] == author_or_translator.first[:1]]
        if len(pid_list) == 1:
            person_ID = pid_list[0]
        elif len(pid_list) > 1:
            person_ID = pid_list[0]
            logging.info("NOTE: Multiple authors exist - " + author_or_translator.last + ", " + author_or_translator.first)
        elif len(pid_list) == 0:
            person_ID = self.check_person_in_db(out, author_or_translator)
        return person_ID
    
    def add_authorList(self, out, model_ID):
        next_authorList_id = self.next_metadata_ID['AuthorList']
        self.next_metadata_ID['AuthorList'] += 1
        insert_metadatas = self.insert_metadatas_template.substitute(metaid=next_authorList_id)
        logging.info(insert_metadatas)
        insert_authorList = self.insert_authorList_template.substitute(metaid=next_authorList_id)
        logging.info(insert_authorList)
        insert_authorList_association = self.insert_model_metadata_associations_template.substitute(metaid=next_authorList_id, modelid=model_ID)
        logging.info(insert_authorList_association)
        
        out.write(insert_metadatas + ';\n')
        out.write(insert_authorList + ';\n')
        out.write(insert_authorList_association + ';\n')
        return next_authorList_id
    
    def compare_author_translator_tuple(self, author, translator):
        comparison_result = cmp(author,translator) == 0
        if not comparison_result:
            if author.last == translator.last:
                author1 = author.first[:1]
                translator1 = translator.first[:1]
                comparison_result = author1 == translator1
        return comparison_result
    
    def process_author_translators(self, out, line, author_tuples, model_ID):  
        # assumes only 1 translator at this point; need to revise if invalid assumption!!!
        # Coded for "fuzzy" comparison of author/translator to match on lastname and first initial
        firstname, __, lastname= line.translator.partition(" ")
        translator = self.Author(lastname, firstname)
        next_authorList_id = self.add_authorList(out, model_ID)
        translator_is_author = False
        author_sequence = 0
        for author in author_tuples:
            person_ID = self.process_person(out, author)
            author_sequence += 1;
            if (self.compare_author_translator_tuple(author, translator)):
                translator_is_author = True
                author_or_translator ="both"
            else:
                author_or_translator = "author"
            self.add_person_to_author_list(out, person_ID, next_authorList_id, self.author_translator[author_or_translator], author_sequence)
        if not translator_is_author:
            person_ID = self.process_person(out, translator)
            self.add_person_to_author_list(out, person_ID, next_authorList_id, self.author_translator["translator"], 0)
            return next_authorList_id
    
    def process_line_pubmed_authors_translators(self, out, line, model_ID):
        pmid = line.pubmedID
        if (pmid is not None):
            if (self.publication_metadata.has_key(pmid)):
                # publication_metadata provides information in db: pubID and authorListID 
                insert_pub_association = self.insert_model_metadata_associations_template.substitute(metaid=self.publication_metadata[pmid].pubID, modelid=model_ID)
                logging.info(insert_pub_association)
                insert_authorlist_association = self.insert_model_metadata_associations_template.substitute(metaid=self.publication_metadata[pmid].authorListID, modelid=model_ID)
                logging.info(insert_authorlist_association)
    
                out.write(insert_pub_association + ';\n')
                out.write(insert_authorlist_association + ';\n')
                
            elif (self.pubmed_title_author.has_key(pmid)):
                # pubmed_title_author provides information found using browser: title: str, authors: [Author(last: str, first: str) ...])
                next_pub_id = self.next_metadata_ID['Publication']
                self.next_metadata_ID['Publication'] += 1
                insert_metadatas = self.insert_metadatas_template.substitute(metaid=next_pub_id)
                logging.info(insert_metadatas)
1                insert_pub = self.insert_pub_template.substitute(metaid=next_pub_id, ref=pmid, title=self.pubmed_title_author[pmid].title)
                logging.info(insert_pub)
                insert_pub_association = self.insert_model_metadata_associations_template.substitute(metaid=next_pub_id, modelid=model_ID)
                logging.info(insert_pub_association)
                
                out.write(insert_metadatas + ';\n')
                out.write(insert_pub + ';\n')
                out.write(insert_pub_association + ';\n')
    
                authorList_id = self.process_author_translators(out, line, self.pubmed_title_author[pmid].authors, model_ID)
                self.publication_metadata[pmid] = self.PublicationMetadataID(next_pub_id, authorList_id)
            else:
                logging.error("PubmedID NOT FOUND!")
        # else need to process authors and translators from file!!!
        else:
            if (line.authors is not None):
                authors = [au.strip() for au in line.authors.split(',')]
                author_tuples = []
                for author in authors:
                    firstname, __, lastname= author.partition(" ")
                    author_tuples.append(self.Author(lastname, firstname))
                authorList_id = self.process_author_translators(out, line, author_tuples, model_ID)
            elif (line.translator is not None):
                authorList_id = self.process_author_translators(out, line, [], model_ID)    
            else:
                logging.error('INVALID INPUT: No pubmedID; No authors; No translators specified>' + str(line))
    
    def process_line_neurolex(self, out, line, model_ID):
        if line.neurolexTerm is None or line.neurolexTerm.strip() == "":
            return

        neurolex_terms = line.neurolexTerm.split(',')
        neurolex_uris = line.neurolexURI.split(',')

        for i in xrange(len(neurolex_terms)):
            neurolex_term = neurolex_terms[i]
            neurolex_uri = neurolex_uris[i]

            if neurolex_term is not None and neurolex_uri is not None and neurolex_uri.lower() != 'none':

                next_neurolex_id = None

                # Check if nlx already exists
                self.dbCursor.execute(self.query_neurolex_uri, (neurolex_uri.strip(),))

                if (self.dbCursor.rowcount == 1):
                    result = self.dbCursor.fetchone()
                    next_neurolex_id = result[0]

                else:
                    next_neurolex_id = self.next_metadata_ID['NeuroLex']
                    self.next_metadata_ID['NeuroLex'] += 1
                    insert_metadatas = self.insert_metadatas_template.substitute(metaid=next_neurolex_id)
                    logging.info(insert_metadatas)
                    insert_neurolex = self.insert_neurolex_template.substitute(metaid=next_neurolex_id, term=neurolex_term, uri=neurolex_uri)
                    logging.info(insert_neurolex)

                    out.write(insert_metadatas + ';\n')
                    out.write(insert_neurolex + ';\n')

                insert_neurolex_association = self.insert_model_metadata_associations_template.substitute(metaid=next_neurolex_id, modelid=model_ID)
                logging.info(insert_neurolex_association)

                out.write(insert_neurolex_association + ';\n')
    
    def process_line_references(self, out, line, model_ID):        
        references = line.references.replace("),(",")),((").split("),(")
        for reference in references:
            resource_name_left_parenthesis, __, resource_URL_right_parenthesis = reference.partition(",")
            resource_name = resource_name_left_parenthesis[1:]
            resource_URL = resource_URL_right_parenthesis[:-1]
            next_refer_id = self.next_metadata_ID['Refer']
            self.next_metadata_ID['Refer'] += 1
            insert_metadatas = self.insert_metadatas_template.substitute(metaid=next_refer_id)
            logging.info(insert_metadatas)
            insert_refer = self.insert_refer_template.substitute(metaid=next_refer_id, resourceid=self.resource_metadata.get(resource_name), resourcename=resource_name,uri=resource_URL)
            logging.info(insert_refer)
            insert_refer_association = self.insert_model_metadata_associations_template.substitute(metaid=next_refer_id, modelid=model_ID)
            logging.info(insert_refer_association)
            if self.resource_metadata.has_key(resource_name):
                out.write(insert_metadatas + ';\n')
                out.write(insert_refer + ';\n')
                out.write(insert_refer_association + ';\n')
            else:
                logging.error('Resource NOT in database: ' + resource_name)
                
    def process_line_keywords(self, out, line, model_ID):
        next_keyword_id = self.next_metadata_ID['Keywords']
        self.next_metadata_ID['Keywords'] += 1
        insert_metadatas = self.insert_metadatas_template.substitute(metaid=next_keyword_id)
        logging.info(insert_metadatas)
        insert_keyword = self.insert_keyword_template.substitute(metaid=next_keyword_id, keywords=line.keywords)
        logging.info(insert_keyword)
        insert_keyword_association = self.insert_model_metadata_associations_template.substitute(metaid=next_keyword_id, modelid=model_ID)
        logging.info(insert_keyword_association)
        
        out.write(insert_metadatas + ';\n')
        out.write(insert_keyword + ';\n')
        out.write(insert_keyword_association + ';\n')

    def process_line_children(self, out, line, model_ID):
        #assumes children have been inserted in db already given by order: channels/synapses, cells, networks
        #Must find children by unique model id in database or ERROR generated
        if (line.children is not None):
            for child in line.children.replace(' ','').split(','):
                try:
                    self.dbCursor.execute(self.query_model_by_filename % (child,))
                    if (self.dbCursor.rowcount == 0):
                        logging.error('Child not found in database: ' + child)
                    else:
                        child_result = self.dbCursor.fetchone()
                        child_model_ID = child_result[0]
                        parent_child_type = model_ID[3:5] + child_model_ID[3:5]
                        if (self.insert_child_template.has_key(parent_child_type)):
                            insert_child_association = self.insert_child_template.get(parent_child_type).substitute(parent=model_ID, child=child_model_ID)
                            logging.info(insert_child_association)
                            out.write(insert_child_association + ';\n')
                        elif parent_child_type == 'NTCH':
                            continue # networks don't have channel children, but are often part of includes in NML file
                        else:
                            logging.error('Incorrect parent-child association')
                except Exception as e:
                    logging.error('Database exception looking for child model: ' + str(e))
                
    def process_input_line(self, out, cp, line):         
        next_model = self.next_NML_model_ID.get(line.modelType)
        self.next_NML_model_ID[line.modelType] += 1
        model_ID = 'NML' + line.modelType + '{0:0>6}'.format(next_model)
        insert_model = self.insert_models_template.substitute(id=model_ID)
        logging.info(insert_model)
        insert_type = self.insert_type_template.get(line.modelType).substitute(id=model_ID, name=line.modelName, fname=line.fileName)
        logging.info(insert_type)

        out.write('-- ' + model_ID + '\n')
        out.write(insert_model + ';\n')
        out.write(insert_type + ';\n')
        
        cp_statement = self.cp_template.substitute(id=model_ID, fname=line.fileName)
        logging.info(cp_statement)
        cp.write(cp_statement + '\n')
        
        self.process_line_references(out, line, model_ID)
        self.process_line_keywords(out, line, model_ID)
        self.process_line_neurolex(out, line, model_ID)
        self.process_line_pubmed_authors_translators(out, line, model_ID)        
        self.process_line_children(out, line, model_ID) 
           
    #------------------------------ init ------------------------------------
    def __init__(self):

        if len(sys.argv) is not 3:
            print("Pass db login info when calling script. e.g.: python BatchNeuroML.py username password")
            return

        logging.basicConfig(level=logging.INFO)    
        self.db = MySQLdb.connect(host=db_server,user=sys.argv[1],passwd=sys.argv[2],db=db_name, use_unicode=1,charset="utf8")
        self.dbCursor = self.db.cursor()
        self.initialize_nexts()
        self.initialize_resources()
        self.load_csv(model_csv_file)
        
        pubmedID_list = list(set([i.pubmedID for i in self.input_csv if i.pubmedID is not None]))
        self.process_pubmed(pubmedID_list)
        
        with open('batch_insert_statements.sql','w') as output_sql:
            with open('cp_statements.sh', 'w') as output_cp:
                for line in self.input_csv:
                    self.process_input_line(output_sql, output_cp, line)
        
        self.dbCursor.close()    
                
BatchNeuroML()