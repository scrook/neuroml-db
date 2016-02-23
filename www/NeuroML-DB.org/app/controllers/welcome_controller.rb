# Redmine - project management software
# Copyright (C) 2006-2013  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class WelcomeController < ApplicationController
  caches_action :robots

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

  def show_model_nif

    @model_id    =params[:model_id].to_s
    substring    =@model_id[0..4]
    @channel_list=Hash.new
    @network_list=Hash.new
    @cell_list   = Hash.new
    @syn_list    = Hash.new
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

      cell_network_assoc=NetworkCellAssociation.where(:Cell_ID => @model_id.to_s)
      cna               =NetworkCellAssociation.new
      cell_network_assoc.each do |cna|
        @network_list[cna.Network_ID] = Network.find_by_Network_ID(cna.Network_ID).Network_Name
        if @network_list.any?
          @model_id = @network_list.keys[0]
        else
          @model_id=params[:model_id].to_s
        end
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
      if  @network_list.any?
        @model_id = @network_list.keys[0]
      else
        @model_id = @cell_list.keys[0]
      end

      puts @model_id
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
        ref                          =Refer.find_by_Reference_ID(@metadata_id)
        @ref_list[ref.Reference_URI] = ref.Reference_Resource
      end

      if substring2 == "400"
        keyword_model  =OtherKeyword.find_by_Other_Keyword_ID(@metadata_id)
        @keywords_model=keyword_model.Other_Keyword_term
      end

      if substring2 == "300"
        nlx                        =Neurolex.find_by_NeuroLex_ID(@metadata_id)
        @nlx_list[nlx.NeuroLex_URI]= nlx.NeuroLex_Term
      end

      if substring2 == "200"

      end

      if substring2 == "100"
        authlist=AuthorListAssociation.where(:AuthorList_ID => @metadata_id.to_s)
        ala     =AuthorListAssociation.new
        authlist.each do |ala|
          translator=ala.is_translator.to_s

          auth_name =String.new
          personname=Person.find_by_Person_ID(ala.Person_ID)
          auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s

          if translator == "0" || translator == "2"
            @auth_list.push(auth_name)
          end

          if translator == "1" || translator == "2"
            @trans_list.push(auth_name)
          end

        end
      end
    end


#keyword_model=KeywordSymbolTable.find_by_Model_ID(@model_id.to_s)
#@keywords_model=keyword_model.Keyword
    @model_id=params[:model_id].to_s
    if !@file.blank?
      filename =@file.split('/')
      @filename=filename.last
#@destinationFile=@filename[0..-4]+"html"
#@res=`/usr/bin/python /home/neuromine/NeuroML2_To_HTML/convert.py #{@file} > /home/neuromine/newred_dbsrch/public/NeuroML2_To_HTML/#{@destinationFile}`
    end
    render :partial => "show_model_nif"
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


  def model_info
    @model_id    =params[:model_id].to_s
    @resources   =Array.new
    substring    =@model_id[0..4]
    @channel_list=Hash.new
    @network_list=Hash.new
    @cell_list   = Hash.new
    @syn_list    = Hash.new
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

      cell_network_assoc=NetworkCellAssociation.where(:Cell_ID => @model_id.to_s)
      cna               =NetworkCellAssociation.new
      cell_network_assoc.each do |cna|
        @network_list[cna.Network_ID] = Network.find_by_Network_ID(cna.Network_ID).Network_Name
#commenting as of now to avoid inheritance
# if @network_list.any?
#@model_id = @network_list.keys[0]
#else
#@model_id=params[:model_id].to_s
#end
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
#commenting as of now to avoid inheritance
#if  @network_list.any? 
#@model_id = @network_list.keys[0]
#else
#@model_id = @cell_list.keys[0]
#end

#puts @model_id
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
        ref                          =Refer.find_by_Reference_ID(@metadata_id)
        @ref_list[ref.Reference_URI] = ref.Reference_Resource

        @resources.push(Resource.find_by_Resource_ID(ref.Reference_Resource_ID))
      end

      if substring2 == "400"
        keyword_model  =OtherKeyword.find_by_Other_Keyword_ID(@metadata_id)
        @keywords_model=keyword_model.Other_Keyword_term
      end

      if substring2 == "300"
        nlx                        =Neurolex.find_by_NeuroLex_ID(@metadata_id)
        @nlx_list[nlx.NeuroLex_URI]= nlx.NeuroLex_Term
      end

      if substring2 == "200"

      end

      if substring2 == "100"
        authlist=AuthorListAssociation.where(:AuthorList_ID => @metadata_id.to_s)
        ala     =AuthorListAssociation.new
        authlist.each do |ala|
          translator=ala.is_translator.to_s

          auth_name =String.new
          personname=Person.find_by_Person_ID(ala.Person_ID)
          auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s

          if translator == "0" || translator == "2"
            @auth_list.push(auth_name)
          end

          if translator == "1" || translator == "2"
            @trans_list.push(auth_name)
          end

        end
      end
    end


#keyword_model=KeywordSymbolTable.find_by_Model_ID(@model_id.to_s)
#@keywords_model=keyword_model.Keyword
    @model_id=params[:model_id].to_s
    if !@file.blank?
      filename =@file.split('/')
      @filename=filename.last
#@destinationFile=@filename[0..-4]+"html"
#@res=`/usr/bin/python /home/neuromine/NeuroML2_To_HTML/convert.py #{@file} > /home/neuromine/newred_dbsrch/public/NeuroML2_To_HTML/#{@destinationFile}`
    end
    render :partial => "model_info"


  end


  def searchi_model
    render :layout => 'searchresults'
  end

#============================== Python Search
  def search_python

    search_text = params[:q].gsub('"','\"')

    @resultset =`/usr/bin/python /var/www/neuroml-db.org_ontology/main.py #{search_text}`

    if @resultset.to_s.length == 0
      render :partial => 'no_results' and return
    end

    puts @resultset.to_s
    resultstring=@resultset.to_s
    indexdiff   = 0

    indexdiff=resultstring.index('}') - resultstring.index('{')

    if indexdiff != 1

      cleanstring =resultstring[resultstring.index('{')..resultstring.index(']}')+1]
      cleanstring = cleanstring
                        .gsub(':', '=>')
                        .gsub("u'","'")
                        .gsub("_"," ")


      @result_hash=eval(cleanstring)

      @ont_headers=Array.new
      @ont_ids    =Array.new
      @ont_names  =Array.new
      @ont_types  =Array.new
      @ont_relations = []

      for key, value in @result_hash
        puts key.to_s
        @ont_headers.push(key)

        for relationship in value

          temparray=relationship["ModelIds"].to_a

          for eachid in temparray

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

            substring=eachid[0..4]

            puts "\n\n************"+substring
            if substring == "NMLCL"
              cell=Cell.find_by_Cell_ID(eachid.to_s)
              name=cell.Cell_Name
              type="Cell"
            end

            if substring == "NMLCH"
              channel=Channel.find_by_Channel_ID(eachid.to_s)
              name   =channel.Channel_Name
              type   ="Channel"
            end


            if substring == "NMLNT"
              network=Network.find_by_Network_ID(eachid.to_s)
              name   =network.Network_Name
              type   ="Network"
            end

            if substring == "NMLSY"
              name=Synapse.find_by_Synapse_ID(eachid.to_s)
              type="Synapse"
            end

            @ont_ids.push(eachid)
            @ont_names.push(name)
            @ont_types.push(type)
            @ont_relations.push(relation)
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
      @resultset = connection.execute("#{advanced_query}");
    else
      @resultset = connection.execute("call keyword_search('#{parameter_search_text}',#{keyword_count})");
    end

    ActiveRecord::Base.clear_active_connections!

    @resultset_strings = @resultset.map { |result| result.to_s.gsub(/[^0-9A-Za-z]/, '') }

    @model_ids         =Array.new
    @model_names       =Array.new
    @model_types       =Array.new

    @resultset_strings.each do |result|

      substring=result[0..4]

      if substring == "NMLCL"
        cell=Cell.find_by_Cell_ID(result.to_s)
        name=cell.Cell_Name
        type="Cell"
      end

      if substring == "NMLCH"
        channel=Channel.find_by_Channel_ID(result.to_s)
        name   =channel.Channel_Name
        type   ="Channel"
      end


      if substring == "NMLNT"
        network=Network.find_by_Network_ID(result.to_s)
        name   =network.Network_Name
        type   ="Network"
      end

      if substring == "NMLSY"
        synapse=Synapse.find_by_Synapse_ID(result.to_s)
        name   =synapse.Synapse_Name
        type   ="Synapse"
      end

      @model_ids.push(result)
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

#====================================== End of Keyword Search =============


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
end
