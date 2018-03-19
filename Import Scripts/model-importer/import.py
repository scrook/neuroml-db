# This script will take one or more directory paths as inputs, parse the model info,
# and convert the model into a CSV description, a single directory simulation, or save into NeuroML-DB
# Can be used to modify a model that already exists in the database or import a new model into the db
# Usage examples:
#   For a new model:
#       python import.py "../Sources/OSB/Migliore 2014/inputs/"
#
#   For existing model:
#       python import.py "path/to/existing/models/NML...XX1", "path/to/existing/models/NML...XX2", ...

import sys, os, csv, string, re, urllib2
import xml.etree.ElementTree as ET
import peewee
from peewee import CharField, FloatField, BooleanField, TextField, IntegerField, ForeignKeyField, PrimaryKeyField
from sshtunnel import SSHTunnelForwarder
from playhouse.db_url import connect


class ModelImporter:
    def __init__(self):
        self.out_csv_file = 'models.csv'
        self.model_directories = []
        self.is_existing = False
        self.tree_nodes = {}
        self.roots = []
        self.root_ids = []
        self.model_directory_parent = []

        self.valid_actions = (
            'ignore',
            'UPDATE',
            'ADD'
        )

    def parse_csv(self, csv_path):
        with open(csv_path, "r") as f:
            rows = list(csv.DictReader(f))

        for row in rows:
            row['parents'] = []
            self.tree_nodes[row['file_name']] = row

        for node in self.tree_nodes.values():
            if node["action"] not in self.valid_actions:
                raise Exception(
                    "Invalid action: '" + node["action"] + "'. Allowed actions are: " + str(self.valid_actions))

            for val in node.values():
                if "DB:" in val or "|NML:" in val:
                    raise Exception("Unresolved conflict in CSV file: '" + val + "'")

            self.parse_multi_value_field(node, "translators")
            self.parse_multi_value_field(node, "references")
            self.parse_multi_value_field(node, "neurolex_terms")
            self.parse_multi_value_field(node, "keywords")
            self.parse_multi_value_field(node, "children")

            node["pubmed_id"] = node["pubmed_id"].lower()

            node["translators"] = [{
                'last_name': string.split(t, ",")[0],
                'first_name': string.split(t, ",")[1]
            }
                for t in node["translators"]]

            node['children'] = [{'file_name': c} for c in node['children']]

            for child in node['children']:
                child_file = child['file_name']
                self.tree_nodes[child_file]['parents'].append(node['file_name'])
        self.get_roots()

    def parse_multi_value_field(self, node, field):
        value = node[field]

        if value != "":
            node[field] = string.split(value, "|")
        else:
            node[field] = []

    def parse_directories(self, model_directories):

        for dir in model_directories:
            self.model_directories.append(os.path.abspath(dir) + "/")

        self.is_existing = self.is_existing_model()

        if self.is_existing:
            self.root_ids = self.get_root_model_ids()
            self.model_directory_parent = re.compile('(.*)/NML').search(self.model_directories[0]).groups(1)[0]

        if self.is_existing:
            self.parse_db_stored()
        else:
            self.parse_simulation()

    def parse_simulation(self):
        # Start with NML Files directly in the directory
        root_files = [file
                      for file in os.listdir(self.model_directories[0])
                      if self.is_nml2_file(file)]

        self.tree_nodes = {}

        for root_file in root_files:
            self.parse_file_tree(root_file)

        self.get_roots()

        for node in self.tree_nodes.values():
            node['model_type'] = self.get_type(node)

    def get_roots(self):
        # Roots are nodes without parents
        self.roots = [node for node in self.tree_nodes.values() if not node['parents']]

        for node in self.roots:
            node["is_root"] = True

    def parse_db_stored(self):
        self.connect_to_db()
        self.tree_nodes = {}
        for root_id in self.root_ids:
            self.fetch_model_tree(root_id)
        self.get_roots()

    def to_db_stored(self):
        db = self.connect_to_db()

        with db.atomic() as transation:
            # ADDS - update or link may depend on record existing
            adds = [n for n in self.tree_nodes.values() if n["action"] == "ADD"]
            for model in adds:
                self.add_model(model)

            for model in adds:
                self.add_links(model)

            # UPDATES - may add or remove a link
            updates = [n for n in self.tree_nodes.values() if n["action"] == "UPDATE"]
            for model in updates:
                self.update_model(model)

            for model in updates:
                self.add_links(model)

            # # DEBUG
            # self.parse_directories(['/home/justas/Repositories/neuroml-db/www/NeuroMLmodels/NMLCL000400/'])
            # raise NotImplementedError()

    def add_links(self, parent_node):

        # Clear the existing child list first
        Model_Model_Associations\
            .delete()\
            .where(Model_Model_Associations.Parent == parent_node["model_id"])\
            .execute()

        # (Re)add children links
        for child in parent_node["children"]:
            child_node = self.tree_nodes[child["file_name"]]

            if child_node["model_id"] in ("", None):
                raise Exception("All child files must have an NML-DB ID: " + child["file_name"])

            Model_Model_Associations.create(
                Parent=parent_node["model_id"],
                Child=child_node["model_id"]
            )

    def update_model(self, node):
        if node["model_id"] == "":
            raise Exception("When UPDATE'ing, model ID must not be blank: " + node["file_name"])

        model = Models.get(Models.Model_ID == node["model_id"])

        # Type and ID cannot be changed
        model.Name = node["model_name"]
        model.File_Name = node["file_name"]
        model.Notes = node["notes"]
        model.Publication = self.get_or_create_publication(node["pubmed_id"])
        model.save()


        # Translators, references, neurolexes, keywords
        self.add_metadata(model, node)

        # channel protocol
        if model.Type_id == "CH":
            channel = Channels.get(Channels.Model == model)

            # ok to change - though simulation has to be rerun - need a way to mark simulations to be rerun in general - perhaps at model table level
            channel.Channel_Type = node["channel_protocol"]
            channel.save()

    def add_model(self, node):
        if node["model_id"] != "":
            raise Exception("When ADD'ing, model ID should be blank: " + node["model_id"])

        type_id = Model_Types.get(Model_Types.Name == node['model_type']).ID

        new_model_id = 'NML' + type_id + str(Models.select(peewee.fn.MAX(Models.ID_Helper)).scalar() + 1).zfill(6)

        model = Models.create(
            Model_ID=new_model_id,
            Name=node["model_name"],
            File_Name=node["file_name"],
            Notes=node["notes"],
            Publication=self.get_or_create_publication(node["pubmed_id"])
        )

        node["model_id"] = new_model_id

        # Translators, references, neurolexes, keywords
        self.add_metadata(model, node)

        # channel protocol
        if type_id == "CH":
            Channels.create(
                Model=model,
                Type=node["channel_protocol"]
            )

    def add_metadata(self, model, node):
        # Nodes contain the complete sets of these, clear the links before adding to avoid dups
        Model_Translators.delete().where(Model_Translators.Model == model).execute()
        Model_References.delete().where(Model_References.Model == model).execute()
        Model_Neurolexes.delete().where(Model_Neurolexes.Model == model).execute()
        Model_Other_Keywords.delete().where(Model_Other_Keywords.Model == model).execute()

        # Translators
        for i, translator in enumerate(node["translators"]):
            Model_Translators.create(
                Translator=self.get_or_create_author(translator["first_name"], translator["last_name"]),
                Model=model,
                Translator_Sequence=i
            )

        # references
        for node_ref in node["references"]:
            Model_References.create(
                Model=model,
                Reference=self.get_or_create_reference(node_ref)
            )

        # neurolexes -
        for node_nlx in node["neurolex_terms"]:
            Model_Neurolexes.create(
                Model=model,
                Neurolex=self.get_neurolex(node_nlx)
            )

        # keywords - create new if cant find exact match
        for kwd in node["keywords"]:
            Model_Other_Keywords.create(
                Model=model,
                Other_Keyword=self.get_or_create_keyword(kwd)
            )

    def get_or_create_keyword(self, keyword_string):
        keyword, created = Other_Keywords.get_or_create(Other_Keyword_Term=keyword_string)
        return keyword

    def get_neurolex(self, term_string):
        # use existing nlx - raise error if cannot match exactly
        try:
            return Neurolexes.get(Neurolexes.NeuroLex_Term == term_string)
        except:
            raise Exception(
                "Neurolexes must exist and match exactly the value of NeuroLex_Term field: '" + term_string + "'")

    def get_or_create_reference(self, ref_url):
        # Create if dont exist, detect from url which resource to use - show error if can't find one
        existing = Refers.get_or_none(Refers.Reference_URI == ref_url)

        if existing is not None:
            return existing
        else:
            try:
                resource = Resources \
                    .select(Resources, Refers) \
                    .join(Refers) \
                    .where(peewee.fn.LEFT(peewee.fn.LOWER(Refers.Reference_URI), 40) == peewee.fn.LEFT(
                    peewee.fn.LOWER(ref_url), 40)) \
                    .first()
            except:
                raise Exception("Could not find a matching resource for reference URL:" + ref_url)

            ref = Refers()
            ref.Reference_URI = ref_url
            ref.Resource = resource
            ref.save()

            return ref

    def get_or_create_publication(self, pubmed_ref):
        existing = Publications.get_or_none(Publications.Pubmed_Ref == pubmed_ref)

        if existing is not None:
            return existing
        else:
            title, year, authors = self.get_pub_info_from_nih(pubmed_ref)

            pub = Publications.create(
                Pubmed_Ref=pubmed_ref,
                Full_Title=title,
                Year=year
            )

            for i, author in enumerate(authors):
                db_author = self.get_or_create_author(author["first_name"], author["last_name"])

                Publication_Authors.create(
                    Publication=pub,
                    Author=db_author,
                    Author_Sequence=i
                )

            return pub

    def get_or_create_author(self, fname, lname):
        author, created = People.get_or_create(Person_Last_Name=lname, Person_First_Name=fname)
        return author

    def get_pub_info_from_nih(self, pubmed_ref):
        pmid = pubmed_ref.lower().replace("pubmed/", "")  # Comes in as e.g. "pubmed/16293591"

        url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&id=' + pmid
        pm_Tree = ET.ElementTree(file=urllib2.urlopen(url))

        title = pm_Tree.findall('.//ArticleTitle')[0].text

        author_list = pm_Tree.findall('.//Author')
        authors = [{
            "last_name": author.find('LastName').text,
            "first_name": author.find('ForeName').text}
            for author in author_list]

        year = int(pm_Tree.findall('.//PubDate')[0].find('Year').text)

        return title, year, authors

    def to_simulation(self):
        raise NotImplementedError()

    def fetch_model_tree(self, id, parent=None):
        print("Fetching " + id + "...")
        model = self.fetch_model_record(id)

        if model.File_Name in self.tree_nodes:

            # Add only parent info, if any
            if parent is not None:
                self.tree_nodes[model.File_Name]['parents'].append(parent)

            # Skip otherwise
            return

        node = self.get_blank_node()
        self.tree_nodes[model.File_Name] = node

        node["model_id"] = model.Model_ID
        node["model_name"] = model.Name
        node["model_type"] = model.Type.Name
        node["file_name"] = model.File_Name
        node["pubmed_id"] = model.Publication.Pubmed_Ref

        node["translators"] = [
            {"last_name": t.Person_Last_Name,
             "first_name": t.Person_First_Name}
            for t in model.Translators]

        node["references"] = [r.Reference_URI for r in model.References]
        node["neurolex_terms"] = [r.NeuroLex_Term for r in model.Neurolexes]
        node["keywords"] = [r.Other_Keyword_Term for r in model.Keywords]

        if model.Type.Name == "Channel":
            node["channel_protocol"] = model.Channel[0].Channel_Type

        node["notes"] = model.Notes
        node["path"] = self.server_path_to_local_path(model.File)

        if parent is not None:
            node["parents"].append(parent)

        node["children"] = [{
                'file_name': c.File_Name,
                'nml_id': c.Model_ID,
                'server_path': c.File,
                'local_path': self.server_path_to_local_path(c.File)
            }
            for c in model.Children]

        for child in node["children"]:
            self.fetch_model_tree(child['nml_id'], parent=node["file_name"])

    def fetch_model_record(self, id):
        result = Models \
            .select(Models, Model_Types, Publications) \
            .join(Model_Types) \
            .switch(Models) \
            .join(Publications) \
            .where(Models.Model_ID == id) \
            .first()

        result.Translators = People.select().join(Model_Translators).where(Model_Translators.Model == id)
        result.References = Refers.select().join(Model_References).where(Model_References.Model == id)
        result.Neurolexes = Neurolexes.select().join(Model_Neurolexes).where(Model_Neurolexes.Model == id)
        result.Keywords = Other_Keywords.select().join(Model_Other_Keywords).where(Model_Other_Keywords.Model == id)

        result.Children = Models.select(Models.Model_ID, Models.File, Models.File_Name) \
            .join(Model_Model_Associations, on=(Model_Model_Associations.Child == Models.Model_ID)) \
            .where(Model_Model_Associations.Parent == id)

        return result

    def server_path_to_local_path(self, server_path):
        return server_path.replace('/var/www/NeuroMLmodels', self.model_directory_parent)

    def local_path_to_server_path(self, local_path):
        return local_path.replace(self.model_directory_parent, '/var/www/NeuroMLmodels')

    def get_type(self, node):
        path = node["path"]

        if path.endswith(".cell.nml"):
            return "Cell"

        if path.endswith(".channel.nml"):
            return "Channel"

        if path.endswith(".synapse.nml"):
            return "Synapse"

        if path.endswith(".net.nml"):
            return "Network"

        root = self.get_xml_root(path)

        for element in root:
            tag = element.tag.lower()

            if 'concentration' in tag:
                return "Concentration"

            if 'gapjunction' in tag or 'synapse' in tag:
                return "Synapse"

        raise Exception("Could not determine the type of:" + path)

    def to_csv(self):
        with open(self.out_csv_file, 'wb') as file:
            writer = csv.writer(file, delimiter=',')
            self.write_header(writer)

            for root in self.roots:
                self.write_node(writer, root)

            for node in self.tree_nodes.values():
                if node not in self.roots:
                    self.write_node(writer, node)

    @staticmethod
    def get_blank_node():
        return {
            'action': 'ignore',
            'model_id': '',
            'model_name': '',
            'model_type': '',
            'file_name': '',
            'path': '',
            'dir': '',
            'children': [],
            'parents': [],
            'pubmed_id': '',
            'translators': [],
            'references': [],
            'neurolex_terms': [],
            'keywords': [],
            'channel_protocol': '',
            'notes': '',
            'is_root': False
        }

    @staticmethod
    def write_header(writer):
        writer.writerow([
            'action',
            'is_root',
            'model_id',
            'model_name',
            'model_type',
            'file_name',
            'pubmed_id',
            'translators',
            'references',
            'neurolex_terms',
            'keywords',
            'channel_protocol',
            'notes',
            'path',
            'children',
        ])

    @staticmethod
    def write_node(writer, node):
        writer.writerow([
            node['action'],
            node['is_root'],
            node['model_id'],
            node['model_name'],
            node['model_type'],
            node['file_name'],
            node['pubmed_id'],
            string.join([t["last_name"] + "," + t["first_name"] for t in node['translators']], '|'),
            string.join(node['references'], '|'),
            string.join(node['neurolex_terms'], '|'),
            string.join(node['keywords'], '|'),
            node['channel_protocol'],
            node['notes'],
            node['path'],
            string.join([c['file_name'] for c in node['children']], '|'),
        ])

    def file_exists(self, path):
        return os.path.exists(path)

    def is_nml2_file(self, file_name):
        return file_name.endswith(".nml")

    def is_existing_model(self):
        return len(self.get_root_model_ids()) > 0

    def get_root_model_ids(self):
        result = []

        for dir in self.model_directories:
            try:
                root_dir = dir.split("/")[-2]

                # Check if parent dir is named as an NML-DB ID
                if root_dir.startswith("NML") and len(root_dir) == 11:
                    result.append(root_dir)
            except:
                pass

        return result

    def parse_file_tree(self, file, parent=None):
        # If file already parsed
        if file in self.tree_nodes:

            # Add only parent info, if any
            if parent is not None:
                self.tree_nodes[file]['parents'].append(parent)

            # Skip otherwise
            return

        # Create node
        node = self.get_blank_node()

        node['file_name'] = file
        node['dir'] = self.model_directories[0]
        node['path'] = self.model_directories[0] + file

        if parent is not None:
            node['parents'].append(parent)

        # Add it to the tree
        self.tree_nodes[file] = node

        # Read xml
        root = self.get_xml_root(node['path'])

        # Get list of node children
        for child in root:
            if child.tag == "{http://www.neuroml.org/schema/neuroml2}include":
                if child.attrib['href']:
                    child_rel_path = child.attrib['href']
                    child_file = os.path.basename(child_rel_path)
                    node['children'].append({'file_name': child_file})

        # Repeat for each child
        for child_file in node['children']:
            self.parse_file_tree(child_file['file_name'], parent=node['file_name'])

    def get_xml_root(self, file_path):
        tree = ET.parse(file_path)
        root = tree.getroot()
        return root

    def connect_to_db(self):
        if hasattr(self, "db") and self.db is not None:
            return self.db

        pwd = os.environ["NMLDBPWD"]  # This needs to be set to the password

        if pwd == '':
            raise Exception("The environment variable 'NMLDBPWD' needs to contain the password to the NML database")

        server = SSHTunnelForwarder(
            ('149.169.30.15', 2200),  # '149.169.30.15' - spike.asu.edu - testing server
            ssh_username='neuromine',
            ssh_password=pwd,
            remote_bind_address=('127.0.0.1', 3306)
        )

        print("Connecting to server...")
        server.start()

        print("Connecting to MySQL database...")
        db = connect('mysql://neuromldb2:' + pwd + '@127.0.0.1:' + str(server.local_bind_port) + '/neuromldb')

        db_proxy.initialize(db)

        self.server = server
        self.db = db

        return db

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        if hasattr(self, "server"):
            self.server.close()

        if hasattr(self, "db"):
            self.db.close()


db_proxy = peewee.Proxy()


class BaseModel(peewee.Model):
    class Meta:
        database = db_proxy
        only_save_dirty = True


class Model_Types(BaseModel):
    ID = CharField(primary_key=True)
    Name = TextField()


class Publications(BaseModel):
    Publication_ID = PrimaryKeyField()
    Pubmed_Ref = TextField()
    Year = IntegerField()
    Full_Title = TextField()


class People(BaseModel):
    Person_ID = PrimaryKeyField()
    Person_First_Name = TextField()
    Person_Middle_Name = TextField()
    Person_Last_Name = TextField()
    Institution = TextField()
    Email = TextField()


class Publication_Authors(BaseModel):
    Publication = ForeignKeyField(Publications, field='Publication_ID', backref="Authors")
    Author = ForeignKeyField(People, field='Person_ID', backref="Publications")
    Author_Sequence = IntegerField()

    class Meta:
        primary_key = peewee.CompositeKey('Publication', 'Author')


class Models(BaseModel):
    Model_ID = CharField(primary_key=True)
    Type = ForeignKeyField(Model_Types, field="ID", column_name="Type")
    Name = TextField()
    Publication = ForeignKeyField(Publications, field="Publication_ID", backref='Models')
    Directory_Path = TextField()
    File_Name = TextField()
    File = TextField()
    Notes = TextField()
    ID_Helper = IntegerField()


class Model_Model_Associations(BaseModel):
    Parent = ForeignKeyField(Models, field='Model_ID', backref="Children")
    Child = ForeignKeyField(Models, field='Model_ID', backref="Parents")

    class Meta:
        primary_key = peewee.CompositeKey('Parent', 'Child')


class Channel_Types(BaseModel):
    ID = TextField(primary_key=True)
    Name = TextField()


class Channels(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="Channel", primary_key=True)
    Type = ForeignKeyField(Channel_Types, field="ID", column_name="Channel_Type")


class Model_Translators(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="Translators")
    Translator = ForeignKeyField(People, field='Person_ID', backref="Translations")
    Translator_Sequence = IntegerField()

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Translator')


class Neurolexes(BaseModel):
    NeuroLex_ID = PrimaryKeyField()
    NeuroLex_URI = TextField()
    NeuroLex_Term = TextField()


class Model_Neurolexes(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="Neurolexes")
    Neurolex = ForeignKeyField(Neurolexes, field='NeuroLex_ID', backref="Models")

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Neurolex')


class Resources(BaseModel):
    Resource_ID = PrimaryKeyField()
    Name = TextField()
    LogoUrl = TextField()
    HomePageUrl = TextField()
    SciCrunch_RRID = TextField()


class Refers(BaseModel):
    Reference_ID = PrimaryKeyField()
    Resource = ForeignKeyField(Resources, field='Resource_ID', backref="Resources", column_name='Reference_Resource_ID')
    Reference_URI = TextField()


class Model_References(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="References")
    Reference = ForeignKeyField(Refers, field='Reference_ID', backref="Models")

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Reference')


class Other_Keywords(BaseModel):
    Other_Keyword_ID = PrimaryKeyField()
    Other_Keyword_Term = TextField()


class Model_Other_Keywords(BaseModel):
    Model = ForeignKeyField(Models, field='Model_ID', backref="Keywords")
    Other_Keyword = ForeignKeyField(Other_Keywords, field='Other_Keyword_ID', backref="Models")

    class Meta:
        primary_key = peewee.CompositeKey('Model', 'Other_Keyword')


import pydevd

pydevd.settrace('192.168.177.1', port=4202, suspend=False)

command = sys.argv[1]
params = sys.argv[2:]

if command == "to_csv":
    with ModelImporter() as mi:
        mi.parse_directories(params)
        mi.to_csv()

if command == "to_db":
    with ModelImporter() as mi:
        mi.parse_csv(params[0])
        mi.to_db_stored()

if command == "validate":
    with ModelImporter() as db_version, ModelImporter() as sim_version:
        # Build node tree from the DB data
        db_version.parse_directories(params)

        # Convert the DB tree to single-folder simulation
        db_version.to_simulation("sim")

        # Build the tree from the simulation files
        sim_version.parse_directories(params)

        # Compare the db tree to the simulation tree - generate comparison CSV
        db_version.compare_to(sim_version)
