class WelcomeController < ApplicationController
  caches_action :robots

  def model_info
    @model_id    =params[:model_id].to_s
    @resources   =Array.new
    substring    =@model_id[0..4]
    @channel_list=Hash.new
    @network_list=Hash.new
    @cell_list   = Hash.new
    @syn_list    = Hash.new
    @conc_list   = Hash.new
    @auth_list   = Array.new
    @trans_list  = Array.new
    @nlx_list    = Hash.new
    @ref_list    = Hash.new
    @pub_list    = Hash.new
    @trans_list  = Array.new
    if substring == "NMLCL"
      cell =Cell.find_by_Cell_ID(@model_id.to_s)
      @name=cell.Cell_Name
      @type="Cell"
      @file=cell.MorphML_File

      cell_channel_assoc=CellChannelAssociation.where(:Cell_ID => @model_id.to_s)
      cca               =CellChannelAssociation.new
      cell_channel_assoc.each do |cca|
        @channel_list[cca.Channel_ID] = Channel.find_by_Channel_ID(cca.Channel_ID).Channel_Name
      end

      cell_synapse_assoc=CellSynapseAssociation.where(:Cell_ID => @model_id.to_s)
      csa               =CellSynapseAssociation.new
      cell_synapse_assoc.each do |csa|
        @syn_list[csa.Synapse_ID] = Synapse.find_by_Synapse_ID(csa.Synapse_ID).Synapse_Name
      end

      cell_concentration_assoc=CellConcentrationAssociation.where(:Cell_ID => @model_id.to_s)
      cca               =CellConcentrationAssociation.new
      cell_concentration_assoc.each do |cca|
        @conc_list[cca.Concentration_ID] = Concentration.find_by_Concentration_ID(cca.Concentration_ID).Concentration_Name
      end

      cell_network_assoc=NetworkCellAssociation.where(:Cell_ID => @model_id.to_s)
      cna               =NetworkCellAssociation.new
      cell_network_assoc.each do |cna|
        @network_list[cna.Network_ID] = Network.find_by_Network_ID(cna.Network_ID).Network_Name
      end
    end

    if substring == "NMLCH"
      channel=Channel.find_by_Channel_ID(@model_id.to_s)
      @name  =channel.Channel_Name
      @type  ="Channel"
      @file  =channel.ChannelML_File

      channel_cell_assoc=CellChannelAssociation.where(:Channel_ID => @model_id.to_s)
      cca               =CellChannelAssociation.new
      channel_cell_assoc.each do |cca|
        @cell_list[cca.Cell_ID] = Cell.find_by_Cell_ID(cca.Cell_ID).Cell_Name
      end
      puts 'hierarcial get'
      puts @model_id
      cell_id = @cell_list.keys[0]
      puts cell_id
      network_cell_assoc=NetworkCellAssociation.where(:Cell_ID => cell_id.to_s)
      cna               =NetworkCellAssociation.new
      network_cell_assoc.each do |cna|
        @network_list[cna.Network_ID] = Network.find_by_Network_ID(cna.Network_ID).Network_Name
      end
    end


    if substring == "NMLNT"
      network=Network.find_by_Network_ID(@model_id.to_s)
      @name  =network.Network_Name
      @type  ="Network"
      @file  =network.NetworkML_File

      network_cell_assoc=NetworkCellAssociation.where(:Network_ID => @model_id.to_s)
      nca               =NetworkCellAssociation.new
      network_cell_assoc.each do |nca|
        @cell_list[nca.Cell_ID] = Cell.find_by_Cell_ID(nca.Cell_ID).Cell_Name
      end

      network_syn_assoc=NetworkSynapseAssociation.where(:Network_ID => @model_id.to_s)
      nsa              =NetworkSynapseAssociation.new
      network_syn_assoc.each do |nsa|
        @syn_list[nsa.Synapse_ID] = Synapse.find_by_Synapse_ID(nsa.Synapse_ID).Synapse_Name
      end

      network_conc_assoc=NetworkConcentrationAssociation.where(:Network_ID => @model_id.to_s)
      nca              =NetworkConcentrationAssociation.new
      network_conc_assoc.each do |nca|
        @conc_list[nca.Concentration_ID] = Concentration.find_by_Concentration_ID(nca.Concentration_ID).Concentration_Name
      end
    end

    if substring == "NMLSY"
      synapse=Synapse.find_by_Synapse_ID(@model_id.to_s)
      @name  =synapse.Synapse_Name
      @type  ="Synapse"
      @file  =synapse.Synapse_File

      cell_synapse_assoc=CellSynapseAssociation.where(:Synapse_ID => @model_id.to_s)
      csa               =CellSynapseAssociation.new
      cell_synapse_assoc.each do |csa|
        @cell_list[csa.Cell_ID] = Cell.find_by_Cell_ID(csa.Cell_ID).Cell_Name
      end


      network_syn_assoc=NetworkSynapseAssociation.where(:Synapse_ID => @model_id.to_s)
      sna              =NetworkSynapseAssociation.new
      network_syn_assoc.each do |sna|
        @network_list[sna.Network_ID] = Network.find_by_Network_ID(sna.Network_ID).Network_Name
      end
    end

    if substring == "NMLCN"
      concentration=Concentration.find_by_Concentration_ID(@model_id.to_s)
      @name  =concentration.Concentration_Name
      @type  ="Concentration"
      @file  =concentration.Concentration_File

      cell_concentration_assoc=CellConcentrationAssociation.where(:Concentration_ID => @model_id.to_s)
      cca               =CellConcentrationAssociation.new
      cell_concentration_assoc.each do |cca|
        @cell_list[cca.Cell_ID] = Cell.find_by_Cell_ID(cca.Cell_ID).Cell_Name
      end


      network_concentration_assoc=NetworkConcentrationAssociation.where(:Concentration_ID => @model_id.to_s)
      cna              =NetworkConcentrationAssociation.new
      network_concentration_assoc.each do |cna|
        @network_list[cna.Network_ID] = Network.find_by_Network_ID(cna.Network_ID).Network_Name
      end
    end

    model_metadata_assoc=ModelMetadataAssociation.where(:Model_ID => @model_id.to_s)
    res                 =ModelMetadataAssociation.new


    model_metadata_assoc.each do |res|
      @metadata_id=res.Metadata_ID.to_s
      substring2  =@metadata_id[0..2]

      if substring2 == "600"
        publication                      =Publication.find_by_Publication_ID(@metadata_id)
        @pub_list[publication.Pubmed_Ref]=publication.Full_Title
      end

      if substring2 == "500"
        ref = Refer.find_by_Reference_ID(@metadata_id)
        resource = Resource.find_by_Resource_ID(ref.Reference_Resource_ID)

        @ref_list[ref.Reference_URI] = resource.Name

        @resources.push(resource)
      end

      if substring2 == "400"
        keyword_model  =OtherKeyword.find_by_Other_Keyword_ID(@metadata_id)
        @keywords_model=keyword_model.Other_Keyword_term
      end

      if substring2 == "300"
        nlx                        =Neurolex.find_by_NeuroLex_ID(@metadata_id)
        @nlx_list[nlx.NeuroLex_URI]= nlx.NeuroLex_Term
      end

      if substring2 == "100"
        fill_authors_translators
      end
    end


    @model_id=params[:model_id].to_s
    if !@file.blank?
      filename =@file.split('/')
      @filename=filename.last
    end

    render :partial => "model_info"


  end

  def fill_authors_translators
    authors = AuthorListAssociation
                  .where("AuthorList_ID = " + @metadata_id.to_s + " and is_translator IN ('0','2')")
                  .joins("INNER JOIN people ON people.Person_ID = author_list_associations.Person_ID")
                  .order("author_sequence, people.Person_Last_Name")

    translators = AuthorListAssociation
                      .where("AuthorList_ID = " + @metadata_id.to_s + " and is_translator IN ('1','2')")
                      .joins("INNER JOIN people ON people.Person_ID = author_list_associations.Person_ID")
                      .order("people.Person_Last_Name")

    ala =AuthorListAssociation.new

    authors.each do |ala|

      auth_name =String.new
      personname=Person.find_by_Person_ID(ala.Person_ID)
      auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s

      @auth_list.push(auth_name)

    end

    translators.each do |ala|

      auth_name =String.new
      personname=Person.find_by_Person_ID(ala.Person_ID)
      auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s

      @trans_list.push(auth_name)

    end
  end

#============================== Python Search
  def search_python

    search_text = params[:q].gsub('"','\"')

    logger.warn("search_python?q=#{params[:q]}")

    @resultset =`/usr/bin/python /var/www/NeuroML-DB.org_Ontology/main.py #{search_text} 2>&1`

    if @resultset.index('{') == nil
	    logger.warn("python search returned: '#{@resultset}'")
    end

    if @resultset.to_s.length == 0
      render :partial => 'no_results' and return
    end

    puts @resultset.to_s
    resultstring=@resultset.to_s
    indexdiff   = 0

    startPython = resultstring.index('-BEGIN-PYTHON-')
    endPython = resultstring.index('-END-PYTHON-')
    indexdiff = endPython - startPython

    if indexdiff != 1

      cleanstring =resultstring[startPython..(endPython-3)]

      cleanstring = cleanstring
                        .gsub("defaultdict(<type 'list'>, ","")
                        .gsub("-BEGIN-PYTHON-","")
                        .gsub(':', '=>')
                        .gsub("u'","'")
                        .gsub("_"," ")


      @result_hash=eval(cleanstring)

      @ont_headers=Array.new
      @ont_ids    =Array.new
      @ont_names  =Array.new
      @ont_types  =Array.new
      @ont_relations = []

      #logger.warn(@result_hash)

      modelNames = @result_hash["ModelNames"]

      for key, value in @result_hash
        if key != "ModelNames"
          puts key.to_s
          @ont_headers.push(key)

          for relationship in value

            temparray=relationship["ModelIds"].to_a

            for modelID in temparray

              if key == "Gap Relationships"

                relation = {
                    :Type => :Gap,
                    :End1 => {
                        :Subject => relationship["end1"],
                        :Property => relationship["relationship1"]
                    },
                    :End2 => {
                        :Subject => relationship["end2"],
                        :Property => relationship["relationship2"]
                    }
                }

              elsif key == "Direct Relationship Analogues"

                relation = {
                    :Type => :Direct,
                    :Subject => relationship["relationshipTo"],
                    :Property => relationship["relationship"]
                 }

              elsif key == "Keyword Relations"

                relation = {
                    :Type => :Keyword,
                    :Subject => relationship["name"],
                    :Property => relationship["relationship"]
                }

              end

              type = getModelType(modelID)
              name = modelNames[modelID]

              @ont_ids.push(modelID)
              @ont_names.push(name)
              @ont_types.push(type)
              @ont_relations.push(relation)
            end
          end
        end

      end
    end

    if indexdiff != 1 && @ont_ids.length > 0
      render :partial => 'ontology_search_results',
             :locals => {
                 :ont_ids => @ont_ids,
                 :ont_names => @ont_names,
                 :ont_types => @ont_types,
                 :ont_relations => @ont_relations,
                 :result_hash => @result_hash,
                 :query => search_text,
             }
    else
      render :partial => 'no_results'
    end
  end

#============================================ End of Python Search ================


#===================================== Keyword Search ======================
  def search_process
    @search_text  =params[:q].to_s
    all           =params[:all].to_s
    exact         =params[:exact].to_s
    any           =params[:any].to_s
    none          =params[:none].to_s
    advanced_query=""

    if all != ""
      all           =all.split(' ')
      all_like      =all.map { |x| "keyword like " + "'%" + x + "%'" }
      all_like      =all_like.join(' and ')
      advanced_query=all_like
    end

    if exact != "" && all != ""
      exact          ="'%"+exact+"%'"
      advanced_query = advanced_query + " and keyword like " + exact
    end

    if exact != "" && all == ""
      exact          ="'%"+exact+"%'"
      advanced_query = "keyword like " + exact
    end

    if any != "" and (all != "" or exact != "")
      any            =any.split(' ')
      any_like       =any.map { |x| "keyword like " + "'%" + x + "%'" }
      any_like       =any_like.join(' or ')
      advanced_query = advanced_query + " and (" + any_like + ")"
    end

    if any != "" and all == "" and exact == ""
      any            =any.split(' ')
      any_like       =any.map { |x| "keyword like " + "'%" + x + "%'" }
      any_like       =any_like.join(' or ')
      advanced_query = "(" + any_like + ")"
    end

    if none != "" and (all != "" or exact != "" or any != "")
      none         =none.split(' ')
      none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

      none_not_like=none_not_like.join(' and ')

      advanced_query=advanced_query + " and " + none_not_like

    end

    if none != "" and all == "" and exact == "" and any == ""
      none         =none.split(' ')
      none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

      none_not_like=none_not_like.join(' and ')

      advanced_query= none_not_like
    end


    advanced_query = "SELECT Model_ID FROM keyword_symbol_tables WHERE "+advanced_query

    parameter_search_text=@search_text.split.join(" ")
    keyword_array        =parameter_search_text.split(' ')
    keyword_count        =keyword_array.size

    connection           = ActiveRecord::Base.connection

    if all != "" or exact != "" or any != "" or none != ""
      @dbResult = connection.execute("#{advanced_query}");
    else
      @dbResult = connection.execute("call keyword_search('#{parameter_search_text}',#{keyword_count})");
    end

    ActiveRecord::Base.clear_active_connections!

    @model_ids         =Array.new
    @model_names       =Array.new
    @model_types       =Array.new

    @dbResult.each do |row|

      modelID = row[0]
      name = row[1]
      type = getModelType(modelID)

      @model_ids.push(modelID)
      @model_names.push(name)
      @model_types.push(type)

    end

    if @model_ids.count != 0

      render :partial => 'keyword_results_list',
             :locals => {
                 :model_ids => @model_ids,
                 :model_names => @model_names,
                 :model_types => @model_types
             }

    else

      render :partial => 'no_results'

    end

  end

  def getModelType(modelID)

    modelTypeCode=modelID[0..4]

    if modelTypeCode == "NMLCL"
      type="Cell"

    elsif modelTypeCode == "NMLCH"
      type ="Channel"

    elsif modelTypeCode == "NMLNT"
      type ="Network"

    elsif modelTypeCode == "NMLSY"
      type ="Synapse"

    elsif modelTypeCode == "NMLCN"
      type ="Concentration"
    end

    return type
  end

#====================================== End of Keyword Search =============

  def submission
    @fname             =params[:fname].to_s
    @mname             =params[:mname].to_s
    @lname             = params[:lname].to_s
    @email             = params[:email].to_s
    @institution       = params[:instname].to_s
    @modelname         = params[:model].to_s
    @model_contributor = params[:model_contributor].to_s
    @pubmed            =params[:pubmed].to_s
    @modref            = params[:refrences].to_s
    @moddesc           = params[:model_desc].to_s
    @keywords          = params[:keywords_model].to_s
    @comments          = params[:notes].to_s
    @post              = params[:file]
    @model_dir         = Dir.home + "/models/" + (@modelname.split(' ')).join('_')
    if @post.blank? or @fname.blank? or @modelname.blank? or @lname.blank? or @email.blank?
      redirect_to('/submission_error')

    else
      Dir.mkdir(@model_dir.to_s, 0700) #=> 0

      target_file = @model_dir + "/" + @post.original_filename
      upload_file = File.open(target_file.to_s, "wb")
      upload_file.write(@post.read)
      upload_file.close
      @test  =Array.new
      @test  =params[:pubmed]
      #@test.each do |num|
      #xxi3puts num
      #end

      @fpath = target_file.to_s
      Modelupload.create(:FirstName => @fname, :MiddleName => @mname, :LastName => @lname, :ModelName => @modelname, :Email => @email, :Institution => @institution, :Publication => @pubmed, :Modelref => @modref, :Description => @moddesc, :Contributor => @model_contributor, :Modelspath => @fpath, :Keywords => @keywords, :Comments => @comments)
    end
  end


# region Other Page Methods

  def index
    @news     = News.latest User.current
    @projects = Project.latest User.current
  end


  def home_db
  end

  def documentation
  end

  def model_submit
    @cells=Modelupload.all
  end

  def robots
    @projects = Project.all_public.active
    render :layout => false, :content_type => 'text/plain'
  end

  def neuromlv2
  end

  def extend_neuroml
  end

  def lems
  end

  def relevant_publications
  end

  def workshops
  end

  def tool_support
  end

  def validate
  end

  def neuron_tools
  end

  def pynn
  end

  def x3dtools
  end

  def browse_models
  end

  def search_result
    @cells=Modelupload.all
  end

  def searchi_model
    render :layout => 'searchresults'
  end

  def history
  end

  def scientific_committee
  end

  def acknowledgements
  end

  def lems_dev
  end

  def libnml
  end

  def compatibility
  end

  def specifications
  end

  def examples
  end

  def introduction
  end

  def newsevents
  end

  def workshop2012
  end

  def workshop2011
  end

  def workshop2010
  end

  def workshop2009
  end

  def CNS_workshop
  end

# endregion
end
