class WelcomeController < ApplicationController
  caches_action :robots
  layout "welcome"

  def model_info
    @model_id    =params[:model_id].to_s
    substring    = @model_id[0..4]

    @resources   = []
    @channel_list, @network_list, @cell_list, @syn_list, @conc_list = [], [], [] , [], []
    @auth_list, @trans_list, @trans_list = [], [], [], []
    @nlx_list, @ref_list, @pub_list = {}, {}, {}
    @shortPub    = ""


    #model =Model.find_by_Model_ID(@model_id)
    details = Model.GetModelDetails(@model_id)
    model = details[:model]
    @versions = details[:versions]
    @similar_cells = details[:similar_cells]
    @ephyz_clusters = details[:ephyz_clusters]

    @name=model["Name"]
    @type=model["Type"]
    @file=model["File"]
    @filename=model["File_Name"]
    @model_notes = model["Notes"]
    @compartments = model["Compartments"]
    @model = model

    @morphometrics = Model.GetMorphometrics(@model_id)
    @gif_path = Model.GetModelGifPath(@model_id)

    relatedModels = Array(details[:children]) + Array(details[:parents])

    relatedModels.each do |relative|
      @network_list << relative if relative["Type"] == "Network"
      @cell_list << relative if relative["Type"] == "Cell"
      @channel_list << relative if relative["Type"] == "Channel"
      @syn_list << relative if relative["Type"] == "Synapse"
      @conc_list << relative if relative["Type"] == "Concentration"
    end


    details[:references].each do |ref|
      @ref_list[ref["Reference_URI"]] = ref["Name"]
      @resources.push(ref)
    end

    # Strange: Here it's treated as 1-1, in DB it's 1-many
    details[:keywords].each do |kwd|
      @keywords_model=kwd["Other_Keyword_term"]
    end

    details[:neurolex_ids].each do |nlx|
      @nlx_list[nlx["NeuroLex_URI"]]= nlx["NeuroLex_Term"]
    end

    # Strange: Here it's 1-many, in DB it's 1-1
    pub = details[:publication]
    @publication = pub[:record]
    @pub_list[pub[:record]["Pubmed_Ref"]] = pub[:record]["Full_Title"]
    @shortPub = pub[:short]

    pub[:authors].each do |person|
      auth_name = person["Person_First_Name"] + " " + person["Person_Last_Name"]

      if person["is_translator"] == 1
        @trans_list.push(auth_name)
      else
        @auth_list.push(auth_name)
      end
    end

    @complexity = details[:complexity]

    if params[:partial].to_s == "true"
      render :partial => "model_info"
    else
      render
    end

  end

  helper_method :model_atag_params

  def model_atag_params(id)
    return "href=\"/model_info?model_id=#{id}\"".html_safe
  end

  helper_method :display_field

  def display_field(structure, field, format, nilValue)
    if structure[field] == nil
      return nilValue
    else
      return format % structure[field]
    end
  end


#============================== Python Search
  def search_python

    search_text = params[:q].gsub('"','\"')


    @resultset =`/usr/bin/python /var/www/NeuroML-DB.org_Ontology/main.py #{search_text} 2>&1`

    # if @resultset.index('{') == nil
	   #  logger.warn("python search returned: '#{@resultset}'")
    # end

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


#===================================== Keyword Search ======================
  def search_process

    @search_text  = params[:q].to_s

    @dbResult = Model.SearchKeyword(@search_text)

    @model_ids         =Array.new
    @model_names       =Array.new
    @model_types       =Array.new

    @dbResult.each do |row|
      @model_ids.push(row["Model_ID"])
      @model_names.push(row["Name"])
      @model_types.push(row["Type"])

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

  def search_test

    @queries = ExpectedSearchResult.all

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

  def api

  end

  def gallery

  end

# endregion
end
