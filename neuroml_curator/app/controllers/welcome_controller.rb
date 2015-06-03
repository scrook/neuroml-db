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
  before_filter :require_login
  caches_action :robots

  def index
    @news = News.latest User.current
    @projects = Project.latest User.current
  end

  def model_submit
    @cells=Cell.all
  end

  def edit_models
  end

  def curate_model
  end

  def render_xml_file
    filename=params[:file].to_s
    render :text => File.read(filename), :content_type => 'application/xml'
  end

  def list_models
    @select = params[:select_models].to_s
    @network_models = Array.new
    @cell_models = Array.new
    @syn_models = Array.new
    @channels = Array.new
    if @select == "1"
      networks = Network.all
      networks.each do |nt|
        @network_models.push(nt)
      end
    elsif @select == "2"
      cells = Cell.all
      cells.each do |cl|
        @cell_models.push(cl)
      end
    elsif @select == "3"
      synapses = Synapse.all
      synapses.each do |syn|
        @syn_models.push(syn)
      end
    elsif @select == "4"
      channls = Channel.all
      channls.each do |ch|
        @channels.push(ch)
      end
    elsif @select == "0"
      networks = Network.all
      networks.each do |nt|
        @network_models.push(nt)
      end

      cells = Cell.all
      cells.each do |cl|
        @cell_models.push(cl)
      end
      synapses = Synapse.all
      synapses.each do |syn|
        @syn_models.push(syn)
      end

      channls = Channel.all
      channls.each do |ch|
        @channels.push(ch)
      end
    else
      flash.now[:notice] = "Invalid ModelID selected"
      redirect_to :back
    end
  end


  def new_publication
    seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID")
    @seq_nbr_metadata = seq_nbr2.Seq_Nbr
    @format_mid = '%06i' % @seq_nbr_metadata
    @metadata_id = "6" + @format_mid
    params[:publication][:Publication_ID] = @metadata_id
    Metadata.create(:Metadata_ID => @metadata_id);
    ModelMetadataAssociation.create(:Model_ID => params[:model][:Model_ID].to_s,:Metadata_ID => @metadata_id);
    Publication.create(params[:publication]);
    seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1;
    seq_nbr2.save;
    @models_list = {:model_id => params[:model][:Model_ID].to_s }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def new_neurolex
    seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID")
    @seq_nbr_metadata = seq_nbr2.Seq_Nbr
    @format_mid = '%06i' % @seq_nbr_metadata
    @metadata_id = "3" + @format_mid
    params[:neurolex][:NeuroLex_ID] = @metadata_id
    Metadata.create(:Metadata_ID => @metadata_id);
    ModelMetadataAssociation.create(:Model_ID => params[:model][:Model_ID].to_s,:Metadata_ID => @metadata_id);
    Neurolex.create(params[:neurolex]);
    seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1;
    seq_nbr2.save;
    @models_list = {:model_id => params[:model][:Model_ID].to_s }
    redirect_to :back,:flash => {:models_list => @models_list}

  end

  def new_reference
    seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID")
    @seq_nbr_metadata = seq_nbr2.Seq_Nbr
    @format_mid = '%06i' % @seq_nbr_metadata
    @metadata_id = "5" + @format_mid
    params[:reference][:Reference_ID] = @metadata_id
    Metadata.create(:Metadata_ID => @metadata_id);
    ModelMetadataAssociation.create(:Model_ID => params[:model][:Model_ID].to_s,:Metadata_ID => @metadata_id);
    Reference.create(params[:reference]);
    seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1;
    seq_nbr2.save;
    @models_list = {:model_id => params[:model][:Model_ID].to_s }
    redirect_to :back,:flash => {:models_list => @models_list}

  end

  def new_keywords
    seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID")
    @seq_nbr_metadata = seq_nbr2.Seq_Nbr
    @format_mid = '%06i' % @seq_nbr_metadata
    @metadata_id = "4" + @format_mid
    params[:other_keyword][:Other_Keyword_ID] = @metadata_id
    Metadata.create(:Metadata_ID => @metadata_id);
    ModelMetadataAssociation.create(:Model_ID => params[:model][:Model_ID].to_s,:Metadata_ID => @metadata_id);
    OtherKeyword.create(params[:other_keyword]);
    seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1;
    seq_nbr2.save;
    @models_list = {:model_id => params[:model][:Model_ID].to_s }
    redirect_to :back,:flash => {:models_list => @models_list}

  end

  def new_author
    meta = ModelMetadataAssociation.where(:Model_ID => params[:model][:Model_ID].to_s)
    meta.each do |res|
      @metadata_id=res.Metadata_ID.to_s
      substring=@metadata_id[0..2]
      if substring == "100"
        @auth_list=AuthorListAssociation.where(:AuthorList_ID => @metadata_id)
        @authorlist_id = @metadata_id
      end
    end
    if @auth_list.blank?
      seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID")
      @seq_nbr_metadata = seq_nbr2.Seq_Nbr
      @format_mid = '%06i' % @seq_nbr_metadata
      @metadata_id = "1" + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => params[:model][:Model_ID].to_s,:Metadata_ID => @metadata_id);
      AuthorList.create(:AuthorList_ID => @metadata_id);
      @authorlist_id = @metadata_id
      seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1;
      seq_nbr2.save;
    end

    @find_person=Person.where(:Person_First_Name => params[:person][:Person_First_Name],:Person_Last_Name => params[:person][:Person_Last_Name])
    if @find_person.blank?
      seq_nbr3=Sequence.find_by_Attr_Name("Person_ID");
      @seq_nbr_pid = seq_nbr3.Seq_Nbr;
      @format_pid = '%06i' % @seq_nbr_pid;
      @person_id = "2" + @format_pid;
      Person.create(:Person_ID =>@person_id,:Person_First_Name => params[:person][:Person_First_Name],:Person_Middle_Name => params[:person][:Person_Middle_Name],:Person_Last_Name => params[:person][:Person_Last_Name],:Instituition => params[:person][:Instituition],:Email => params[:person][:Email]);
      AuthorListAssociation.create(:AuthorList_ID => @authorlist_id,:Person_ID => @person_id,:is_translator => params[:cont_select]);
      @seq_nbr_pid = @seq_nbr_pid+1
      seq_nbr3.Seq_Nbr = @seq_nbr_pid
      seq_nbr3.save

    else
      per=Person.new
      @find_person.each do |per|
        @person_id = per.Person_ID
      end
      AuthorListAssociation.create(:AuthorList_ID => @authorlist_id,:Person_ID => @person_id,:is_translator => params[:cont_select]);
    end
    @models_list = {:model_id => params[:model][:Model_ID].to_s }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def edit_curate_model
    @sub_id=params[:modelupload_list][:model_id].to_s
    if !@sub_id.blank?
      @model = Modelupload.find_by_SubmissionID(@sub_id)
      @modeltype = @model.Modeltype.to_s
      puts @modeltype
      if @modeltype == "Cell"
        @cell=Cell.new
        @cell.Cell_Name = @model.ModelName.to_s
        @cell.MorphML_File = @model.Modelspath.to_s
        @cell.Comments = @model.Description.to_s
        @cell.Upload_Time = @model.Upload_Time.to_s
      end
      if @modeltype == "Network"
        @network = Network.new
        @network.Network_Name = @model.ModelName.to_s
        @network.NetworkML_File = @model.Modelspath.to_s
        @network.Comments = @model.Description.to_s
        @network.Upload_Time = @model.Upload_Time.to_s
      end
      if @modeltype == "Channel"
        @channel = Channel.new
        @channel.Channel_Name = @model.ModelName.to_s
        @channel.ChannelML_File = @model.Modelspath.to_s
        @channel.Comments = @model.Description.to_s
        @channel.Upload_Time = @model.Upload_Time.to_s
      end
      if @modeltype == "Synapse"
        @synapse = Synapse.new
        @synapse.Synapse_Name = @model.ModelName.to_s
        @synapse.Synapse_File = @model.Modelspath.to_s
        @synapse.Comments = @model.Description.to_s
        @synapse.Upload_Time = @model.Upload_Time.to_s
      end
      @pub=Publication.new
      @pub.Pubmed_Ref = @model.Publication.to_s
      @ref=Reference.new
      @ref.Reference_URI=@model.Modelref.to_s
      @author = Person.new
      @author.Person_First_Name = @model.FirstName.to_s
      @author.Person_Middle_Name = @model.MiddleName.to_s
      @author.Person_Last_Name = @model.LastName.to_s
      @author.Email = @model.Email.to_s
      @author.Instituition = @model.Institution.to_s
      @keywords = OtherKeyword.new
      @keywords.Other_Keyword_term = @model.Keywords.to_s
      @nlx = Neurolex.new
      @ccha = CellChannelAssociation.new
      @csa = CellSynapseAssociation.new
      @cna = NetworkCellAssociation.new
      @nca = NetworkCellAssociation.new
    end
  end

  def edit_channel
    @channel = params[:channel]
    @channel_id = @channel[:Channel_ID].to_s
    Channel.update(@channel_id,params[:channel])
    @models_list = {:model_id => @channel_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def edit_synapse
    @synapse = params[:synapse]
    @syn_id = @synapse[:Synapse_ID].to_s
    Synapse.update(@syn_id,params[:synapse])
    @models_list = {:model_id => @syn_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def edit_network
    @network = params[:network]
    @network_id = @network[:Network_ID].to_s
    Network.update(@network_id,params[:network])
    @models_list = {:model_id => @network_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def edit_references
    @ref_update =params[:reference]
    @ref_update_id = @ref_update[:Reference_ID].to_s
    return_model = ModelMetadataAssociation.find_by_Metadata_ID(@ref_update_id)
    @return_model_id = return_model.Model_ID.to_s
    if !params[:delete].blank?
      Reference.where(:Reference_ID => @ref_update_id).delete_all
      ModelMetadataAssociation.where(:Metadata_ID => @ref_update_id).delete_all
      Metadata.where(:Metadata_ID => @ref_update_id).delete_all
    else
      Reference.update(@ref_update_id,params[:reference])
    end
    @models_list = {:model_id => @return_model_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def edit_keywords
    @kwords_update =params[:other_keyword]
    @kwords_update_id = @kwords_update[:Other_Keyword_ID].to_s
    return_model = ModelMetadataAssociation.find_by_Metadata_ID(@kwords_update_id)
    @return_model_id = return_model.Model_ID.to_s
    if !params[:delete].blank?
      OtherKeyword.where(:Other_Keyword_ID => @kwords_update_id).delete_all
      ModelMetadataAssociation.where(:Metadata_ID => @kwords_update_id).delete_all
      Metadata.where(:Metadata_ID => @kwords_update_id).delete_all
    else
      OtherKeyword.update(@kwords_update_id,params[:other_keyword])
    end
    @models_list = {:model_id => @return_model_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end


  def edit_author_details
    @auth_update =params[:person]
    @auth_update_id = @auth_update[:Person_ID].to_s
    @model = params[:model]
    @modelid = @model[:Model_ID].to_s
    meta = ModelMetadataAssociation.where(:Model_ID => @modelid)
    res=ModelMetadataAssociation.new
    meta.each do |res|
      @metadata_id=res.Metadata_ID.to_s
      substring=@metadata_id[0..2]
      if substring == "100"
        @auth_list_id= @metadata_id
      end
    end
    if !params[:delete].blank?
      AuthorListAssociation.where(:Person_ID => @auth_update_id).where(:AuthorList_ID => @auth_list_id).delete_all
    else
      Person.update(@auth_update_id,params[:person])
    end
    @models_list = {:model_id => @modelid }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def edit_publication
    @pub_update =params[:publication]
    @pub_update_id = @pub_update[:Publication_ID].to_s
    return_model = ModelMetadataAssociation.find_by_Metadata_ID(@pub_update_id)
    @return_model_id = return_model.Model_ID.to_s
    if !params[:delete].blank?
      Publication.where(:Publication_ID => @pub_update_id).delete_all
      ModelMetadataAssociation.where(:Metadata_ID => @pub_update_id).delete_all
      Metadata.where(:Metadata_ID => @pub_update_id).delete_all
    else
      Publication.update(@pub_update_id,params[:publication])
    end
    @models_list = {:model_id => @return_model_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def edit_neurolex_terms
    @nlx_update =params[:neurolex]
    @nlx_update_id = @nlx_update[:NeuroLex_ID].to_s
    return_model = ModelMetadataAssociation.find_by_Metadata_ID(@nlx_update_id)
    @return_model_id = return_model.Model_ID.to_s
    if !params[:delete].blank?
      Neurolex.where(:NeuroLex_ID => @nlx_update_id).delete_all
      ModelMetadataAssociation.where(:Metadata_ID => @nlx_update_id).delete_all
      Metadata.where(:Metadata_ID => @nlx_update_id).delete_all
    else
      Neurolex.update(@nlx_update_id,params[:neurolex])
    end
    @models_list = {:model_id => @return_model_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def del_channel_cell_associations
    @cca_update  = params[:cells]
    @cca_channel_id = params[:channel][:Channel_ID].to_s
    @cca_update.each do |cca_cell_id|
      CellChannelAssociation.where(:Cell_ID => cca_cell_id.to_s).where(:Channel_ID => @cca_channel_id).delete_all
    end
    @models_list = {:model_id => @cca_channel_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def add_channel_cell_associations
    @cca_add = params[:add_cells]
    @cca_channel_id = params[:channel][:Channel_ID].to_s
    @cca_add.each do |cca_cell_id|
      @cca_test = CellChannelAssociation.where(:Cell_ID => cca_cell_id.to_s).where(:Channel_ID => @cca_channel_id)
      if @cca_test.blank?
        CellChannelAssociation.create(:Cell_ID => cca_cell_id.to_s, :Channel_ID => @cca_channel_id)
      end
    end
    @models_list = {:model_id => @cca_channel_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  include DropdownHelper

  def add_cell

    authors
    author_lists
    publications
    references
    modelsources
    neurolexterms

  end



  def add_cell_channel_associations
    @cca_add = params[:add_channels]
    @cca_cell_id = params[:cell][:Cell_ID].to_s
    @cca_add.each do |cca_channel_id|
      @cca_test = CellChannelAssociation.where(:Cell_ID => @cca_cell_id).where(:Channel_ID => cca_channel_id.to_s)
      if @cca_test.blank?
        CellChannelAssociation.create(:Cell_ID => @cca_cell_id,:Channel_ID => cca_channel_id.to_s)
      end
    end
    @models_list = {:model_id => @cca_cell_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def del_cell_channel_associations
    @cca_update  = params[:channels]
    @cca_cell_id = params[:cell][:Cell_ID].to_s
    @cca_update.each do |cca_channel_id|
      CellChannelAssociation.where(:Cell_ID => @cca_cell_id).where(:Channel_ID => cca_channel_id.to_s).delete_all
    end
    @models_list = {:model_id => @cca_cell_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def add_cell_network_associations
    @cna_add  = params[:add_networks]
    @cna_cell_id = params[:cell][:Cell_ID].to_s
    @cna_add.each do |cna_network_id|
      @cna_test = NetworkCellAssociation.where(:Cell_ID => @cna_cell_id).where(:Network_ID => cna_network_id.to_s)
      if @cna_test.blank?
        NetworkCellAssociation.create(:Cell_ID => @cna_cell_id,:Network_ID => cna_network_id.to_s)
      end
    end
    @models_list = {:model_id => @cna_cell_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end


  def del_cell_network_associations
    @cna_update  = params[:networks]
    @cna_cell_id = params[:cell][:Cell_ID].to_s
    @cna_update.each do |cna_network_id|
      NetworkCellAssociation.where(:Cell_ID => @cna_cell_id).where(:Network_ID => cna_network_id.to_s).delete_all
    end
    @models_list = {:model_id => @cna_cell_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def add_network_cell_associations
    @cna_add  = params[:add_cells]
    @cna_network_id = params[:network][:Network_ID].to_s
    @cna_add.each do |cna_cell_id|
      @cna_test = NetworkCellAssociation.where(:Cell_ID => cna_cell_id.to_s).where(:Network_ID => @cna_network_id)
      if @cna_test.blank?
        NetworkCellAssociation.create(:Cell_ID => cna_cell_id.to_s,:Network_ID => @cna_network_id)
      end
    end
    @models_list = {:model_id => @cna_network_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end


  def del_network_cell_associations
    @cna_update  = params[:cells]
    @cna_network_id = params[:network][:Network_ID].to_s
    @cna_update.each do |cna_cell_id|
      NetworkCellAssociation.where(:Cell_ID => cna_cell_id.to_s).where(:Network_ID => @cna_network_id).delete_all
    end
    @models_list = {:model_id => @cna_network_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def add_network_synapse_associations
    @nsa_add  = params[:add_synapses]
    @nsa_network_id = params[:network][:Network_ID].to_s
    @nsa_add.each do |nsa_syn_id|
      @nsa_test = NetworkSynapseAssociation.where(:Synapse_ID => nsa_syn_id.to_s).where(:Network_ID => @nsa_network_id)
      if @nsa_test.blank?
        NetworkSynapseAssociation.create(:Synapse_ID => nsa_syn_id.to_s,:Network_ID => @nsa_network_id)
      end
    end
    @models_list = {:model_id => @nsa_network_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def add_synapse_network_associations
    @sna_add = params[:add_networks]
    @sna_syn_id = params[:synapse][:Synapse_ID].to_s
    @sna_add.each do |sna_syn_id|
      @sna_test = NetworkSynapseAssociation.where(:Synapse_ID => @sna_syn_id).where(:Network_ID => sna_syn_id.to_s)
      if @sna_test.blank?
        NetworkSynapseAssociation.create(:Synapse_ID => @sna_syn_id , :Network_ID => sna_syn_id.to_s)
      end
    end
    @models_list = {:model_id => @sna_syn_id}
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def del_synapse_network_associations
    @sna_update = params[:networks]
    @sna_syn_id = params[:synapse][:Synapse_ID].to_s
    @sna_update.each do |sna_nw_id|
      NetworkSynapseAssociation.where(:Synapse_ID => @sna_syn_id).where(:Network_ID => sna_nw_id.to_s).delete_all
    end
    @models_list = {:model_id => @sna_syn_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def del_network_synapse_associations
    @nsa_update  = params[:synapses]
    @nsa_network_id = params[:network][:Network_ID].to_s
    @nsa_update.each do |nsa_syn_id|
      NetworkSynapseAssociation.where(:Synapse_ID => nsa_syn_id.to_s).where(:Network_ID => @nsa_network_id).delete_all
    end
    @models_list = {:model_id => @nsa_network_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def del_cell_synapse_associations
    @csa_update  = params[:synapses]
    @csa_cell_id = params[:cell][:Cell_ID].to_s
    @csa_update.each do |csa_syn_id|
      CellSynapseAssociation.where(:Cell_ID => @csa_cell_id).where(:Synapse_ID => csa_syn_id.to_s).delete_all
    end
    @models_list = {:model_id => @csa_cell_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def add_cell_synapse_associations
    @csa_add  = params[:add_synapses]
    @csa_cell_id = params[:cell][:Cell_ID].to_s
    @csa_add.each do |csa_syn_id|
      @csa_test = CellSynapseAssociation.where(:Cell_ID => @csa_cell_id).where(:Synapse_ID => csa_syn_id.to_s)
      if @csa_test.blank?
        CellSynapseAssociation.create(:Cell_ID => @csa_cell_id,:Synapse_ID => csa_syn_id.to_s)
      end
    end
    @models_list = {:model_id => @csa_cell_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end


  def edit_cells
    @cell = params[:cell]
    @cell_id = @cell[:Cell_ID].to_s
    puts @cell_id
    Cell.update(@cell_id,params[:cell])
#@model = Cell.find(@cell_id)
    @models_list = {:model_id => @cell_id }
    puts "in edit_cells"
    puts @models_list.to_s
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def del_synapse_cell_associations
    @csa_update  = params[:cells]
    @csa_syn_id = params[:synapse][:Synapse_ID].to_s
    @csa_update.each do |csa_cell_id|
      CellSynapseAssociation.where(:Cell_ID => csa_cell_id.to_s).where(:Synapse_ID => @csa_syn_id).delete_all
    end
    @models_list = {:model_id => @csa_syn_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end

  def add_synapse_cell_associations
    @csa_add  = params[:add_cells]
    @csa_syn_id = params[:synapse][:Synapse_ID].to_s
    @csa_add.each do |csa_cell_id|
      @csa_test = CellSynapseAssociation.where(:Cell_ID => csa_cell_id.to_s).where(:Synapse_ID => @csa_syn_id)
      if @csa_test.blank?
        CellSynapseAssociation.create(:Cell_ID => csa_cell_id.to_s,:Synapse_ID => @csa_syn_id)
      end
    end
    @models_list = {:model_id => @csa_syn_id }
    redirect_to :back,:flash => {:models_list => @models_list}
  end


  def edit_channels_info
    puts "in edit channel"
#puts flash[:models_list].to_s
#puts params[:models_list].to_s
    @cell_list = Array.new
    @publication_list = Array.new
    @ref_list = Array.new
    @keyword_models = Array.new
    @nlx_list = Array.new
    if !flash.blank?
      @modelhash_id=flash[:models_list]
    else
      @modelhash_id=params[:models_list]
    end
    puts @modelhash_id.to_s
    if !@modelhash_id.blank?
      @channel_id = @modelhash_id[:model_id].to_s
      if !@channel_id.blank?
        @model = Channel.find(@channel_id)
        meta = ModelMetadataAssociation.where(:Model_ID => @channel_id)
        res=ModelMetadataAssociation.new
        puts  res
        meta.each do |res|
          @metadata_id=res.Metadata_ID.to_s

          substring=@metadata_id[0..2]

          if substring == "600"
            @publication_list.push(Publication.find_by_Publication_ID(@metadata_id))
          elsif substring == "500"
            @ref_list.push(Reference.find_by_Reference_ID(@metadata_id))
          elsif substring == "400"
            @keyword_models.push(OtherKeyword.find_by_Other_Keyword_ID(@metadata_id))
          elsif substring == "300"
            @nlx_list.push(Neurolex.find_by_NeuroLex_ID(@metadata_id))
          elsif substring == "100"
            @auth_list=AuthorListAssociation.where(:AuthorList_ID => @metadata_id)
            @person = Array.new
            authors = AuthorListAssociation.new
            @auth_list.each do |authors|
              @person.push(Person.find_by_Person_ID(authors.Person_ID))
            end
          end
        end
        cell_channel_assoc=CellChannelAssociation.where(:Channel_ID => @channel_id)
        cca=CellChannelAssociation.new
        cell_channel_assoc.each do |cca|
          @cell_list.push(Cell.find_by_Cell_ID(cca.Cell_ID.to_s))
        end

        @model_id = Model.find(@channel_id)
      else
        flash.now[:notice] = "Invalid ModelID selected"
        redirect_to :back
      end
    end
  end

  def edit_networks_info
    puts "in edit network"
    @cells_list  = Array.new
    @synapse_list = Array.new
    @publication_list = Array.new
    @ref_list = Array.new
    @keyword_models = Array.new
    @nlx_list = Array.new
#puts flash[:models_list].to_s
#puts params[:models_list].to_s
    if !flash.blank?
      @modelhash_id=flash[:models_list]
    else
      @modelhash_id=params[:models_list]
    end
    puts @modelhash_id.to_s
    if !@modelhash_id.blank?
      @network_id = @modelhash_id[:model_id].to_s
      puts @network_id
      if !@network_id.blank?
        @model = Network.find(@network_id)
        meta = ModelMetadataAssociation.where(:Model_ID => @network_id)
        res=ModelMetadataAssociation.new
        meta.each do |res|
          @metadata_id=res.Metadata_ID.to_s

          substring=@metadata_id[0..2]

          if substring == "600"
            @publication_list.push(Publication.find_by_Publication_ID(@metadata_id))
          elsif substring == "500"
            @ref_list.push(Reference.find_by_Reference_ID(@metadata_id))
          elsif substring == "400"
            @keyword_models.push(OtherKeyword.find_by_Other_Keyword_ID(@metadata_id))
          elsif substring == "300"
            @nlx_list.push(Neurolex.find_by_NeuroLex_ID(@metadata_id))
          elsif substring == "100"
            @auth_list=AuthorListAssociation.where(:AuthorList_ID => @metadata_id)
            @person = Array.new
            authors = AuthorListAssociation.new
            @auth_list.each do |authors|
              @person.push(Person.find_by_Person_ID(authors.Person_ID))
            end

          end

          puts "in edit info"
        end
        cell_network_assoc=NetworkCellAssociation.where(:Network_ID => @network_id)
        cna=NetworkCellAssociation.new
        cell_network_assoc.each do |cna|
          @cells_list.push(Cell.find_by_Cell_ID(cna.Cell_ID.to_s))
        end

        syn_network_assoc = NetworkSynapseAssociation.where(:Network_ID => @network_id)
        nsa = NetworkSynapseAssociation.new
        syn_network_assoc.each do |nsa|
          @synapse_list.push(Synapse.find_by_Synapse_ID(nsa.Synapse_ID.to_s))
        end
        @model_id = Model.find(@network_id)
      else
        flash[:notice] = 'Please select valid ModelID'
        redirect_to :back
      end
    end
  end

  def edit_synapses_info
    @cell_list = Array.new
    @network_list = Array.new
    @publication_list = Array.new
    @ref_list = Array.new
    @keyword_models = Array.new
    @nlx_list = Array.new
    if !flash.blank?
      @modelhash_id=flash[:models_list]
    else
      @modelhash_id=params[:models_list]
    end
    puts @modelhash_id.to_s
    if !@modelhash_id.blank?
      @syn_id = @modelhash_id[:model_id].to_s
      if !@syn_id.blank?
        @model = Synapse.find(@syn_id)
        meta = ModelMetadataAssociation.where(:Model_ID => @syn_id)
        res=ModelMetadataAssociation.new
        meta.each do |res|
          @metadata_id=res.Metadata_ID.to_s

          substring=@metadata_id[0..2]

          if substring == "600"
            @publication_list.push(Publication.find_by_Publication_ID(@metadata_id))
          elsif substring == "500"
            @ref_list.push(Reference.find_by_Reference_ID(@metadata_id))
          elsif substring == "400"
            @keyword_models.push(OtherKeyword.find_by_Other_Keyword_ID(@metadata_id))
          elsif substring == "300"
            @nlx_list.push(Neurolex.find_by_NeuroLex_ID(@metadata_id))
          elsif substring == "100"
            @auth_list=AuthorListAssociation.where(:AuthorList_ID => @metadata_id)
            @person = Array.new
            authors = AuthorListAssociation.new
            @auth_list.each do |authors|
              @person.push(Person.find_by_Person_ID(authors.Person_ID))
            end
          end
        end
        cell_synapse_assoc=CellSynapseAssociation.where(:Synapse_ID => @syn_id)
        csa=CellSynapseAssociation.new
        cell_synapse_assoc.each do |csa|
          @cell_list.push(Cell.find_by_Cell_ID(csa.Cell_ID.to_s))
        end

        syn_network_assoc = NetworkSynapseAssociation.where(:Synapse_ID => @syn_id)
        nsa = NetworkSynapseAssociation.new
        syn_network_assoc.each do |nsa|
          @network_list.push(Network.find_by_Network_ID(nsa.Network_ID.to_s))
        end


        @model_id = Model.find(@syn_id)
      else
        flash[:notice] = 'Please select valid ModelID'
        redirect_to :back
      end
    end
  end

  def add_publication
    @publication=Publication.new
    @model_id = Model.new
    @model_id.Model_ID = params[:modelid].to_s
    render :layout => 'formodals'
  end

  def add_neurolex
    @nlx=Neurolex.new
    @model_id = Model.new
    @model_id.Model_ID = params[:modelid].to_s

    render :layout => 'formodals'
  end

  def add_references
    @reference=Reference.new
    @model_id = Model.new
    @model_id.Model_ID = params[:modelid].to_s

    render :layout => 'formodals'
  end

  def add_author
    @author=Person.new
#@author_list = Author.new
    @model_id = Model.new
    @model_id.Model_ID = params[:modelid].to_s

    render :layout => 'formodals'
  end

  def add_keywords
    @keywords=OtherKeyword.new
    @model_id = Model.new
    @model_id.Model_ID = params[:modelid].to_s

    render :layout => 'formodals'
  end




  def edit_cells_info
    puts "in edit model"
#puts flash[:models_list].to_s
#puts params[:models_list].to_s
    @channel_list = Array.new
    @network_list = Array.new
    @synapse_list = Array.new
    @ref_list = Array.new
    @pub_list = Array.new
    @keyword_model = Array.new
    if !flash.blank?
      @modelhash_id=flash[:models_list]
    else
      @modelhash_id=params[:models_list]
    end
    puts @modelhash_id.to_s
    if !@modelhash_id.blank?
      @cell_id = @modelhash_id[:model_id].to_s
      puts @cell_id
      if !@cell_id.blank?
        @model = Cell.find(@cell_id)
        meta = ModelMetadataAssociation.where(:Model_ID => @cell_id)
        res=ModelMetadataAssociation.new
        meta.each do |res|
          @metadata_id=res.Metadata_ID.to_s

          substring=@metadata_id[0..2]

          if substring == "600"
            @pub_list.push(Publication.find_by_Publication_ID(@metadata_id))
          elsif substring == "500"
            @ref_list.push(Reference.find_by_Reference_ID(@metadata_id))
          elsif substring == "400"
            @keyword_model.push(OtherKeyword.find_by_Other_Keyword_ID(@metadata_id))
          elsif substring == "300"
            @nlx=Neurolex.find_by_NeuroLex_ID(@metadata_id)
          elsif substring == "100"
            @auth_list=AuthorListAssociation.where(:AuthorList_ID => @metadata_id)
            @person = Array.new
            authors = AuthorListAssociation.new
            @auth_list.each do |authors|
              @person.push(Person.find_by_Person_ID(authors.Person_ID))
            end
          end
        end
        cell_channel_assoc=CellChannelAssociation.where(:Cell_ID => @cell_id)
        cca=CellChannelAssociation.new
        cell_channel_assoc.each do |cca|
          @channel_list.push(Channel.find_by_Channel_ID(cca.Channel_ID.to_s))
        end

        cell_synapse_assoc=CellSynapseAssociation.where(:Cell_ID => @cell_id)
        csa=CellSynapseAssociation.new
        cell_synapse_assoc.each do |csa|
          @synapse_list.push(Synapse.find_by_Synapse_ID(csa.Synapse_ID.to_s))
        end

        cell_network_assoc=NetworkCellAssociation.where(:Cell_ID => @cell_id)
        cna=NetworkCellAssociation.new
        cell_network_assoc.each do |cna|
          @network_list.push(Network.find_by_Network_ID(cna.Network_ID.to_s))
        end
        @model_id = Model.find(@cell_id)
        puts "in edit info"
      else
        flash[:notice] = 'Please select valid ModelID'
        redirect_to :back
      end
    end
  end

  def submission
    @fname=params[:fname].to_s
    @mname=params[:mname].to_s
    @lname = params[:lname].to_s
    @email = params[:email].to_s
    @institution = params[:instname].to_s
    @modelname = params[:model].to_s
    @model_contributor = params[:model_contributor].to_s
    @pubmed=params[:pubmed].to_s
    @modref = params[:refrences].to_s
    @moddesc = params[:model_desc].to_s
    @keywords = params[:keywords_model].to_s
    @comments = params[:notes].to_s
    @upload_time = DateTime.now.to_s(:db)
    @post = params[:file]
    @model_dir = Dir.home + "/models/" + (@modelname.split(' ')).join('_')
    if @post.blank? or @fname.blank? or @modelname.blank? or @lname.blank? or @email.blank?
      redirect_to('/submission_error')

    else
      Dir.mkdir(@model_dir.to_s, 0700) #=> 0

      target_file =  @model_dir + "/" + @post.original_filename
      upload_file = File.open(target_file.to_s,"wb")
      upload_file.write(@post.read)
      upload_file.close
      @test=Array.new
      @test=params[:pubmed]
#@test.each do |num|
#xxi3puts num
#end

      @fpath = target_file.to_s
      Modelupload.create(:FirstName => @fname,:MiddleName => @mname,:LastName => @lname,:ModelName => @modelname,:Email => @email,:Institution => @institution,:Publication => @pubmed,:Modelref => @modref,:Description => @moddesc,:Contributor => @model_contributor,:Modelspath => @fpath,:Keywords => @keywords,:Comments => @comments,:Upload_Time => @upload_time)
    end
  end

  def ad_model

    seq_nbr=Sequence.find_by_Attr_Name("Model_ID");
    @seq_nbr_model =seq_nbr.Seq_Nbr
    seq_nbr=Sequence.find_by_Attr_Name("Metadata_ID");
    @seq_nbr_metadata = seq_nbr.Seq_Nbr;
    seq_nbr=Sequence.find_by_Attr_Name("Person_ID");
    @seq_nbr_pid = seq_nbr.Seq_Nbr;
    @firname = params[:fname0].to_s;
    @lasname = params[:lname0].to_s;
    @find_person=Person.where(:Person_First_Name => @firname,:Person_Last_Name => @lasname)
    if @find_person.blank?
      puts "nuill"
    end
    per=Person.new
    @find_person.each do |per|
      puts per.Person_ID
    end
    puts per.Person_ID
  end

  def add_curate_model
    @pubmed_id = params[:publication]
    @ref_uri = params[:reference]
    @nlx_uri = params[:neurolex]
    @other_kwords = params[:other_keyword]

    seq_nbr1=Sequence.find_by_Attr_Name("Model_ID");
    @seq_nbr_model =seq_nbr1.Seq_Nbr
    seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID");
    @seq_nbr_metadata = seq_nbr2.Seq_Nbr;
    seq_nbr3=Sequence.find_by_Attr_Name("Person_ID");
    @seq_nbr_pid = seq_nbr3.Seq_Nbr;

    @model_type = params[:modeltype_select].to_s
    @format_mid = '%06i' % @seq_nbr_model
    if @model_type == 'C'
      @modelid = "NMLCL" + @format_mid
      Model.create(:Model_ID => @modelid)
      Cell.create(:Cell_ID => @modelid, :Cell_Name => params[:cell][:Cell_Name], :MorphML_File => params[:cell][:MorphML_File], :Upload_Time => params[:cell][:Upload_Time], :Comments => params[:cell][:Comments]);
    end
    if @model_type == 'S'
      @modelid = "NMLSY" + @format_mid
      Model.create(:Model_ID => @modelid)
      Synapse.create(:Synapse_ID => @modelid, :Synapse_Name => params[:synapse][:Synapse_Name], :Synapse_File =>  params[:synapse][:Synapse_File], :Upload_Time => params[:synapse][:Upload_Time], :Comments => params[:synapse][:Comments]);
    end
    if @model_type == "Ch"
      @modelid = "NMLCH" + @format_mid
      Model.create(:Model_ID => @modelid)
      Channel.create(:Channel_ID => @modelid, :Channel_Name => params[:channel][:Channel_Name], :ChannelML_File => params[:channel][:ChannelML_File], :Upload_Time => params[:channel][:Upload_Time], :Comments => params[:channel][:Comments]);
    end
    if @model_type == 'N'
      @modelid = "NMLNT" + @format_mid
      Model.create(:Model_ID => @modelid)
      Network.create(:Network_ID => @modelid, :Network_Name => params[:network][:Network_Name], :NetworkML_File => params[:network][:NetworkML_File], :Upload_Time => params[:network][:Upload_Time], :Comments => params[:network][:Comments]);
    end
    seq_nbr1.Seq_Nbr = @seq_nbr_model + 1;
    seq_nbr1.save;

    @format_mid = '%06i' % @seq_nbr_metadata
    @metadata_id = "1" + @format_mid
    @person_fname = params[:person]
    if !@person_fname.blank?
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      AuthorList.create(:AuthorList_ID => @metadata_id);
      @find_person=Person.where(:Person_First_Name => params[:person][:Person_First_Name],:Person_Last_Name => params[:person][:Person_Last_Name])
      if @find_person.blank?
        Person.create(:Person_ID =>@person_id,:Person_First_Name => params[:person][:Person_First_Name],:Person_Middle_Name => params[:person][:Person_Middle_Name],:Person_Last_Name => params[:person][:Person_Last_Name],:Instituition => params[:person][:Instituition],:Email => params[:person][:Email]);
        AuthorListAssociation.create(:AuthorList_ID => @metadata_id,:Person_ID => @person_id,:is_translator => params[:modelupload][:Contributor]);
        @seq_nbr_pid = @seq_nbr_pid+1
      else
        per=Person.new
        @find_person.each do |per|
          @person_id = per.Person_ID
        end
        AuthorListAssociation.create(:AuthorList_ID => @metadata_id,:Person_ID => @person_id,:is_translator => params[:modelupload][:Contributor]);
      end
    end


    seq_nbr3.Seq_Nbr = @seq_nbr_pid
    seq_nbr3.save

    if !@pubmed_id.blank?
      @metadata_id = "6" + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      Publication.create(:Publication_ID => @metadata_id,:Pubmed_Ref => params[:publication][:Pubmed_Ref], :Full_Title => params[:publication][:Full_Title],:Comments => params[:publication][:Comments]);
    end
    if !@ref_uri.blank?
      @metadata_id = "5" + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      Reference.create(:Reference_ID => @metadata_id,:Reference_Resource => params[:reference][:Reference_Resource],:Reference_URI => params[:reference][:Reference_URI],:Comments => params[:reference][:Comments]);
    end
    if !@nlx_uri.blank?
      @metadata_id = "3" + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      Neurolex.create(:NeuroLex_ID => @metadata_id,:NeuroLex_URI => params[:neurolex][:NeuroLex_URI],:NeuroLex_Term => params[:neurolex][:NeuroLex_Term],:Comments => params[:neurolex][:Comments]);
    end
    if !@other_kwords.blank?
      @metadata_id = "4"  + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      OtherKeyword.create(:Other_Keyword_ID => @metadata_id, :Other_Keyword_term => params[:other_keyword][:Other_Keyword_term], :Comments => params[:other_keyword][:Comments]);
    end
    seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1;
    seq_nbr2.save;

    if !params[:cell_channel_association][:Channel_ID].to_s.blank?
      @associated_models = params[:cell_channel_association][:Channel_ID].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'C'
          CellChannelAssociation.create(:Cell_ID => @modelid,:Channel_ID => each_model);
        end
      end
    end

    if !params[:cell_synapse_association][:Cell_ID].to_s.blank?
      @associated_models = params[:cell_synapse_association][:Cell_ID].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'Ch'
          CellChannelAssociation.create(:Channel_ID => @modelid,:Cell_ID => each_model);
        end
        if @model_type == 'S'
          CellSynapseAssociation.create(:Synapse_ID => @modelid,:Cell_ID => each_model);
        end
        if @model_type == 'N'
          NetworkCellAssociation.create(:Network_ID => @modelid,:Cell_ID => each_model);
        end
      end
    end

    if !params[:cell_synapse_association][:Synapse_ID].to_s.blank?
      @associated_models = params[:cell_synapse_association][:Synapse_ID].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'C'
          CellSynapseAssociation.create(:Cell_ID => @modelid,:Synapse_ID => each_model);
        end
        if @model_type == 'N'
          NetworkSynapseAssociation.create(:Network_ID => @modelid,:Synapse_ID => each_model);
        end
      end
    end

    if !params[:network_cell_association][:Network_ID].to_s.blank?
      @associated_models = params[:network_cell_association][:Network_ID].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'C'
          NetworkCellAssociation.create(:Cell_ID => @modelid,:Network_ID => each_model);
        end
        if @model_type == 'S'
          NetworkSynapseAssociation.create(:Synapse_ID => @modelid,:Network_ID => each_model);
        end

      end
    end
    Modelupload.where(:SubmissionID => params[:modelupload][:SubmissionID].to_s).delete_all
  end

  def add_model
    @model_name=params[:model].to_s
    @model_type=params[:mtype_select].to_s
    @model_description = params[:model_desc].to_s
    @upload_time = DateTime.now.to_s(:db)
    @file_path = params[:fpath].to_s
    @pubmed_title = params[:pubmed_title].to_s
    @pubmed_id = params[:pubmed_id].to_s
    @ref_src = params[:ref_src].to_s
    @ref_uri = params[:ref_uri].to_s
    @nlx_uri = params[:nlx_uri].to_s
    @nlx_trm = params[:nlx_trm].to_s
    @other_kwords = params[:keywords_model].to_s
    @comments = params[:notes].to_s

    seq_nbr1=Sequence.find_by_Attr_Name("Model_ID");
    @seq_nbr_model =seq_nbr1.Seq_Nbr
    seq_nbr2=Sequence.find_by_Attr_Name("Metadata_ID");
    @seq_nbr_metadata = seq_nbr2.Seq_Nbr;
    seq_nbr3=Sequence.find_by_Attr_Name("Person_ID");
    @seq_nbr_pid = seq_nbr3.Seq_Nbr;

    @post = params[:file]
    if !@model_name.blank?
      @model_dir = Dir.home + "/models/" + (@model_name.split(' ')).join('_')
      Dir.mkdir(@model_dir.to_s, 0755) unless File.exists?(@model_dir.to_s)
#Dir.mkdir(@model_dir.to_s, 0700) #=> 0
    else
      @model_dir = Dir.home + "/models/"
    end

    if !@post.blank?
      target_file =  @model_dir + "/" + @post.original_filename
      upload_file = File.open(target_file.to_s,"wb")
      upload_file .write(@post.read)
      upload_file.close
      @fpath = target_file.to_s
    else
      @fpath = "Not Specified"
    end

    @format_mid = '%06i' % @seq_nbr_model
    if @model_type == 'C'
      @modelid = "NMLCL" + @format_mid
      Model.create(:Model_ID => @modelid)
      Cell.create(:Cell_ID => @modelid, :Cell_Name => @model_name, :Upload_Time => @upload_time, :Comments => @model_description, :MorphML_File => @fpath);
    end
    if @model_type == 'S'
      @modelid = "NMLSY" + @format_mid
      Model.create(:Model_ID => @modelid)
      Synapse.create(:Synapse_ID => @modelid, :Synapse_Name => @model_name, :Synapse_File => @fpath, :Upload_Time => @upload_time, :Comments => @model_description);
    end
    if @model_type == "Ch"
      @modelid = "NMLCH" + @format_mid
      Model.create(:Model_ID => @modelid)
      Channel.create(:Channel_ID => @modelid, :Channel_Name => @model_name, :Upload_Time => @upload_time, :Comments => @model_description, :ChannelML_File =>  @fpath);
    end
    if @model_type == 'N'
      @modelid = "NMLNT" + @format_mid
      Model.create(:Model_ID => @modelid)
      Network.create(:Network_ID => @modelid, :Network_Name => @model_name, :Upload_Time => @upload_time, :Comments => @model_description , :NetworkML_File => @fpath);
    end
    seq_nbr1.Seq_Nbr = @seq_nbr_model + 1;
    seq_nbr1.save;

    @format_mid = '%06i' % @seq_nbr_metadata
    @metadata_id = "1" + @format_mid
    @person_fname = params[:fname0].to_s
    if !@person_fname.blank?
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      AuthorList.create(:AuthorList_ID => @metadata_id);
#As of now will successively add only for six authors
      (0..5).each do |i|
        @format_pid = '%06i' % @seq_nbr_pid;
        @person_id = "2" + @format_pid;
        @temp_var= "fname" + i.to_s
        @person_fname = params[@temp_var].to_s
        @temp_var= "mname" + i.to_s
        @person_mname = params[@temp_var].to_s
        @temp_var= "lname" + i.to_s
        @person_lname = params[@temp_var].to_s
        @temp_var= "email" + i.to_s
        @person_email = params[@temp_var].to_s
        @temp_var= "instname" + i.to_s
        @person_inst = params[@temp_var].to_s
        @temp_var= "cont_select" + i.to_s
        @person_contrib = params[@temp_var].to_s
        if !@person_fname.blank?
          @find_person=Person.where(:Person_First_Name => @person_fname,:Person_Last_Name => @person_lname)
          if @find_person.blank?
            Person.create(:Person_ID =>@person_id,:Person_First_Name => @person_fname,:Person_Middle_Name =>@person_mname,:Person_Last_Name => @person_lname,:Instituition => @person_inst,:Email => @person_email);
            AuthorListAssociation.create(:AuthorList_ID => @metadata_id,:Person_ID => @person_id,:is_translator => @person_contrib);
            @seq_nbr_pid = @seq_nbr_pid+1
          else
            per=Person.new
            @find_person.each do |per|
              @person_id = per.Person_ID
            end
            AuthorListAssociation.create(:AuthorList_ID => @metadata_id,:Person_ID => @person_id,:is_translator => @person_contrib);
          end
        end
      end

    end

    seq_nbr3.Seq_Nbr = @seq_nbr_pid
    seq_nbr3.save

    if !@pubmed_id.blank?
      @metadata_id = "6" + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      Publication.create(:Publication_ID => @metadata_id,:Pubmed_Ref => @pubmed_id, :Full_Title => @pubmed_title);
    end
    if !@ref_uri.blank?
      @metadata_id = "5" + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      Reference.create(:Reference_ID => @metadata_id,:Reference_Resource => @ref_src,:Reference_URI => @ref_uri);
    end
    if !@nlx_uri.blank?
      @metadata_id = "3" + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      Neurolex.create(:NeuroLex_ID => @metadata_id,:NeuroLex_URI =>@nlx_uri,:NeuroLex_Term => @nlx_trm);
    end
    if !@other_kwords.blank?
      @metadata_id = "4"  + @format_mid
      Metadata.create(:Metadata_ID => @metadata_id);
      ModelMetadataAssociation.create(:Model_ID => @modelid,:Metadata_ID => @metadata_id);
      OtherKeyword.create(:Other_Keyword_ID => @metadata_id, :Other_Keyword_term => @other_kwords, :Comments => @comments);
    end
    seq_nbr2.Seq_Nbr = @seq_nbr_metadata + 1;
    seq_nbr2.save;

    if !params[:assoc_chnl].to_s.blank?
      @associated_models = params[:assoc_chnl].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'C'
          CellChannelAssociation.create(:Cell_ID => @modelid,:Channel_ID => each_model);
        end
      end
    end

    if !params[:assoc_cell].to_s.blank?
      @associated_models = params[:assoc_cell].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'Ch'
          CellChannelAssociation.create(:Channel_ID => @modelid,:Cell_ID => each_model);
        end
        if @model_type == 'S'
          CellSynapseAssociation.create(:Synapse_ID => @modelid,:Cell_ID => each_model);
        end
        if @model_type == 'N'
          NetworkCellAssociation.create(:Network_ID => @modelid,:Cell_ID => each_model);
        end
      end
    end

    if !params[:assoc_syn].to_s.blank?
      @associated_models = params[:assoc_syn].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'C'
          CellSynapseAssociation.create(:Cell_ID => @modelid,:Synapse_ID => each_model);
        end
        if @model_type == 'N'
          NetworkSynapseAssociation.create(:Network_ID => @modelid,:Synapse_ID => each_model);
        end
      end
    end

    if !params[:assoc_nw].to_s.blank?
      @associated_models = params[:assoc_nw].to_s.split(' ')
      @associated_models.each do |each_model|
        if @model_type == 'C'
          NetworkCellAssociation.create(:Cell_ID => @modelid,:Network_ID => each_model);
        end
        if @model_type == 'S'
          NetworkSynapseAssociation.create(:Synapse_ID => @modelid,:Network_ID => each_model);
        end

      end
    end

  end

  def model_info
    @model_id=params[:model_id].to_s
    substring=@model_id[0..4]
    @channel_list=Hash.new
    @network_list=Hash.new
    @cell_list = Hash.new
    @syn_list = Hash.new
    @auth_list = Array.new
    @trans_list = Array.new
    @nlx_list = Hash.new
    @ref_list = Hash.new
    @pub_list = Hash.new
    @trans_list = Array.new
    if substring ==  "NMLCL"
      cell=Cell.find_by_Cell_ID(@model_id.to_s)
      @name=cell.Cell_Name
      @type="Cell"
      @file=cell.MorphML_File

      cell_channel_assoc=CellChannelAssociation.where(:Cell_ID => @model_id.to_s)
      cca=CellChannelAssociation.new
      cell_channel_assoc.each do |cca|
        @channel_list[cca.Channel_ID] = Channel.find_by_Channel_ID(cca.Channel_ID).Channel_Name
      end

      cell_synapse_assoc=CellSynapseAssociation.where(:Cell_ID => @model_id.to_s)
      csa=CellSynapseAssociation.new
      cell_synapse_assoc.each do |csa|
        @syn_list[csa.Synapse_ID] = Synapse.find_by_Synapse_ID(csa.Synapse_ID).Synapse_Name
      end

      cell_network_assoc=NetworkCellAssociation.where(:Cell_ID => @model_id.to_s)
      cna=NetworkCellAssociation.new
      cell_network_assoc.each do |cna|
        @network_list[cna.Network_ID] = Network.find_by_Network_ID(cna.Network_ID).Network_Name
# if @network_list.any?
#@model_id = @network_list.keys[0]
#else
#@model_id=params[:model_id].to_s
#end
      end
    end

    if substring == "NMLCH"
      channel=Channel.find_by_Channel_ID(@model_id.to_s)
      @name=channel.Channel_Name
      @type="Channel"
      @file=channel.ChannelML_File
      channel_cell_assoc=CellChannelAssociation.where(:Channel_ID => @model_id.to_s)
      cca=CellChannelAssociation.new
      channel_cell_assoc.each do |cca|
        @cell_list[cca.Cell_ID] = Cell.find_by_Cell_ID(cca.Cell_ID).Cell_Name
      end
      puts 'hierarcial get'
      puts @model_id
      cell_id = @cell_list.keys[0]
      puts cell_id
      network_cell_assoc=NetworkCellAssociation.where(:Cell_ID => cell_id.to_s)
      cna=NetworkCellAssociation.new
      network_cell_assoc.each do |cna|
        @network_list[cna.Network_ID] = Network.find_by_Network_ID(cna.Network_ID).Network_Name
      end
#if  @network_list.any?
#@model_id = @network_list.keys[0]
#else
#@model_id = @cell_list.keys[0]
#end

      puts @model_id
    end


    if substring == "NMLNT"
      network=Network.find_by_Network_ID(@model_id.to_s)
      @name=network.Network_Name
      @type="Network"
      @file=network.NetworkML_File

      network_cell_assoc=NetworkCellAssociation.where(:Network_ID => @model_id.to_s)
      nca=NetworkCellAssociation.new
      network_cell_assoc.each do |nca|
        @cell_list[nca.Cell_ID] = Cell.find_by_Cell_ID(nca.Cell_ID).Cell_Name
      end

      network_syn_assoc=NetworkSynapseAssociation.where(:Network_ID => @model_id.to_s)
      nsa=NetworkSynapseAssociation.new
      network_syn_assoc.each do |nsa|
        @syn_list[nsa.Synapse_ID] = Synapse.find_by_Synapse_ID(nsa.Synapse_ID).Synapse_Name
      end
    end

    if substring == "NMLSY"
      synapse=Synapse.find_by_Synapse_ID(@model_id.to_s)
      @name=synapse.Synapse_Name
      @type="Synapse"
      @file=synapse.Synapse_File

      cell_synapse_assoc=CellSynapseAssociation.where(:Synapse_ID => @model_id.to_s)
      csa=CellSynapseAssociation.new
      cell_synapse_assoc.each do |csa|
        @cell_list[csa.Cell_ID] = Cell.find_by_Cell_ID(csa.Cell_ID).Cell_Name
      end


      network_syn_assoc=NetworkSynapseAssociation.where(:Synapse_ID => @model_id.to_s)
      sna=NetworkSynapseAssociation.new
      network_syn_assoc.each do |sna|
        @network_list[sna.Network_ID] = Network.find_by_Network_ID(sna.Network_ID).Network_Name
      end
    end

    model_metadata_assoc=ModelMetadataAssociation.where(:Model_ID => @model_id.to_s)
    res=ModelMetadataAssociation.new
    model_metadata_assoc.each do |res|
      @metadata_id=res.Metadata_ID.to_s
      substring2=@metadata_id[0..2]

      if substring2 == "600"
        publication=Publication.find_by_Publication_ID(@metadata_id)
        @pub_list[publication.Pubmed_Ref]=publication.Full_Title
      end

      if substring2 == "500"
        ref=Reference.find_by_Reference_ID(@metadata_id)
        @ref_list[ref.Reference_URI] = ref.Reference_Resource
      end

      if substring2 == "400"
        keyword_model=OtherKeyword.find_by_Other_Keyword_ID(@metadata_id)
        @keywords_model=keyword_model.Other_Keyword_term
      end

      if substring2 == "300"
        nlx=Neurolex.find_by_NeuroLex_ID(@metadata_id)
        @nlx_list[nlx.NeuroLex_URI]= nlx.NeuroLex_Term
      end

      if substring2 == "200"

      end

      if substring2 == "100"
        authlist=AuthorListAssociation.where(:AuthorList_ID => @metadata_id.to_s)
        ala=AuthorListAssociation.new
        authlist.each do |ala|
          translator=ala.is_translator.to_s
          if translator == "0"
            auth_name=String.new
            personname=Person.find_by_Person_ID(ala.Person_ID)
            auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s
            @auth_list.push(auth_name)

#@auth_list.push(ala.Person_ID)
          elsif translator == "1"
            auth_name=String.new
            personname=Person.find_by_Person_ID(ala.Person_ID)
            auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s
            @trans_list.push(auth_name)
          else
            auth_name=String.new
            personname=Person.find_by_Person_ID(ala.Person_ID)
            auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s
            @auth_list.push(auth_name)
#@trans_list.push(auth_name)

          end
        end
      end
    end


#keyword_model=KeywordSymbolTable.find_by_Model_ID(@model_id.to_s)
#@keywords_model=keyword_model.Keyword
    @model_id=params[:model_id].to_s
    if !@file.blank?
      filename=@file.split('/')
      @filename=filename.last
    end
    render :partial => "model_info"


  end

  def model_info_decommisoned
    @model_id=params[:model_id].to_s
    substring=@model_id[0..4]
    @channel_list=Array.new
    @network_list=Array.new
    @cell_list = Array.new
    @syn_list = Array.new
    @auth_list = Array.new
    @trans_list = Array.new
    @nlx_list = Hash.new
    @ref_list = Hash.new
    @pub_list = Hash.new
    if substring ==  "NMLCL"
      cell=Cell.find_by_Cell_ID(@model_id.to_s)
      @name=cell.Cell_Name
      @type="Cell"
      @file=cell.MorphML_File

      cell_channel_assoc=CellChannelAssociation.where(:Cell_ID => @model_id.to_s)
      cca=CellChannelAssociation.new
      cell_channel_assoc.each do |cca|
        @channel = cca.Channel_ID
        @channel_list.push(@channel)
      end

#cell_synapse_assoc=CellSynpaseAssociation.where(:Cell_ID => @model_id.to_s)
#csa=CellSynpaseAssociation.new
#cell_synapse_assoc.each do |csa|
#@synapse = csa.Synapse_ID
#puts @synapse
#end

      cell_network_assoc=NetworkCellAssociation.where(:Cell_ID => @model_id.to_s)
      cna=NetworkCellAssociation.new
      cell_network_assoc.each do |cna|
        @network = cna.Network_ID
        @network_list.push(@network)
      end
    end

    if substring == "NMLCH"
      channel=Channel.find_by_Channel_ID(@model_id.to_s)
      @name=channel.Channel_Name
      @type="Channel"
      @file=channel.ChannelML_File

      channel_cell_assoc=CellChannelAssociation.where(:Channel_ID => @model_id.to_s)
      cca=CellChannelAssociation.new
      channel_cell_assoc.each do |cca|
        @cell = cca.Cell_ID
        @cell_list.push(@cell)
      end
    end


    if substring == "NMLNT"
      network=Network.find_by_Network_ID(@model_id.to_s)
      @name=network.Network_Name
      @type="Network"
      @file=network.NetworkML_File

      network_cell_assoc=NetworkCellAssociation.where(:Network_ID => @model_id.to_s)
      nca=NetworkCellAssociation.new
      network_cell_assoc.each do |nca|
        @cell = nca.Cell_ID
        @cell_list.push(@cell)
      end

#network_syn_assoc=NetworkSynapseAssociation.where(:Network_ID => @model_id.to_s)
#nsa=NetworkSynapseAssociation.new
#network_syn_assoc.each do |nsa|
#@synapse = nsa.Synapse_ID
#@syn_list = @syn_list + " " + @synapse
#end
    end

#if substring == "NMLSY"
#synapse=Synapse.find_by_Synapse_ID(@model_id.to_s)
#@name=synapse.Synapse_Name
#@type="Syanpse"
#@file=synapse.SynapseML_File
#end

    model_metadata_assoc=ModelMetadataAssociation.where(:Model_ID => @model_id.to_s)
    res=ModelMetadataAssociation.new
    model_metadata_assoc.each do |res|
      @metadata_id=res.Metadata_ID.to_s
      substring2=@metadata_id[0..2]

      if substring2 == "600"
        publication=Publication.find_by_Publication_ID(@metadata_id)
        @pub_list[publication.Pubmed_Ref]=publication.Full_Title
      end

      if substring2 == "500"
        ref=Reference.find_by_Reference_ID(@metadata_id)
        @ref_list[ref.Reference_URI] = ref.Reference_Resource
      end

      if substring2 == "400"
        keyword_model=OtherKeyword.find_by_Other_Keyword_ID(@metadata_id)
        @keywords_model=keyword_model.Other_Keyword_term
      end

      if substring2 == "300"
        nlx=Neurolex.find_by_NeuroLex_ID(@metadata_id)
        @nlx_list[nlx.NeuroLex_URI]= nlx.NeuroLex_Term
      end

      if substring2 == "200"

      end

      if substring2 == "100"
        authlist=AuthorListAssociation.where(:AuthorList_ID => @metadata_id.to_s)
        ala=AuthorListAssociation.new
        authlist.each do |ala|
          translator=ala.is_translator.to_s
          auth_name=String.new
          personname=Person.find_by_Person_ID(ala.Person_ID)
          auth_name = personname.Person_First_Name.to_s + " " +personname.Person_Middle_Name.to_s + " " + personname.Person_Last_Name.to_s
          @auth_list.push(auth_name)
          if translator == "0"
#@auth_list.push(ala.Person_ID)
          elsif translator == "1"
            @trans_list.push(ala.Person_ID)
          else @trans_list.push(ala.Person_ID)
          end
        end
      end
    end


#keyword_model=KeywordSymbolTable.find_by_Model_ID(@model_id.to_s)
#@keywords_model=keyword_model.Keyword
    filename=@file.split('/')
    @filename=filename.last
    render :partial => "model_info"


  end




  def search_result
    render :layout => 'searchresults'
  end

#============================== Python Search
  def search_python
    search_text=params[:q]
    @resultset=`/usr/bin/python /tmp/Neurolex_py/pseudo_main.py #{search_text}`
    puts 'getting stuff'
    puts search_text
    if @resultset.to_s.length == 0
      render :partial => 'no_results' and return
    end

    puts @resultset.to_s
    resultstring=@resultset.to_s
    indexdiff = 0

    indexdiff=resultstring.index('}') - resultstring.index('{')

    if indexdiff != 1

      cleanstring=resultstring[resultstring.index('{')..resultstring.index(']}')+1]
      cleanstring=cleanstring.gsub(':','=>')
      @result_hash=eval(cleanstring)

      @ont_headers=Array.new
      @ont_ids=Array.new
      @ont_names=Array.new
      @ont_types=Array.new
      for key,value in @result_hash
        @ont_headers.push(key)
        temparray=value.to_a
        for eachid in temparray
          substring=eachid[0..4]
          puts"\n\n************"+substring
          if substring ==  "NMLCL"
            cell=Cell.find_by_Cell_ID(eachid.to_s)
            name=cell.Cell_Name
            type="Cell"
          end

          if substring == "NMLCH"
            channel=Channel.find_by_Channel_ID(eachid.to_s)
            name=channel.Channel_Name
            type="Channel"
          end


          if substring == "NMLNT"
            network=Network.find_by_Network_ID(eachid.to_s)
            name=network.Network_Name
            type="Network"
          end

#if substring == "NMLSY"
#name=Synapse.find_by_Synapse_ID(eachid.to_s)
#type="Syanpse"
#end
          @ont_ids.push(eachid)
          @ont_names.push(name)
          @ont_types.push(type)
        end

      end
    end

    if   indexdiff != 1
      render :partial => 'ontology_search_results', :locals => {:ont_ids=>@ont_ids,:ont_names=>@ont_names,:ont_types=>@ont_types,:result_hash=>@result_hash}
    else
      render :partial => 'no_results'
    end
  end

#============================================ End of Python Search ================


#===================================== Keyword Search ======================
  def search_process
    search_text=params[:q].to_s
    all=params[:all].to_s
    exact=params[:exact].to_s
    any=params[:any].to_s
    none=params[:none].to_s
    advanced_query=""

    if all != ""
      all=all.split(' ')
      all_like=all.map {|x| "keyword like " + "'%" + x + "%'" }
      all_like=all_like.join(' and ')
      advanced_query=all_like
    end

    if exact != "" && all != ""
      exact="'%"+exact+"%'"
      advanced_query = advanced_query + " and keyword like " + exact
    end

    if exact != "" && all == ""
      exact="'%"+exact+"%'"
      advanced_query = "keyword like " + exact
    end

    if any != "" and ( all != "" or exact != "" )
      any=any.split(' ')
      any_like=any.map { |x| "keyword like " + "'%" + x + "%'" }
      any_like=any_like.join(' or ')
      advanced_query = advanced_query + " and (" + any_like + ")"
    end

    if any != "" and all == "" and exact == ""
      any=any.split(' ')
      any_like=any.map { |x| "keyword like " + "'%" + x + "%'" }
      any_like=any_like.join(' or ')
      advanced_query = "(" + any_like + ")"
    end

    if none != "" and (all != "" or exact != "" or any != "")
      none=none.split(' ')
      none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

      none_not_like=none_not_like.join(' and ')

      advanced_query=advanced_query + " and " + none_not_like

    end

    if none != "" and all == "" and exact == "" and any == ""
      none=none.split(' ')
      none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

      none_not_like=none_not_like.join(' and ')

      advanced_query= none_not_like
    end





    advanced_query = "SELECT Model_ID FROM keyword_symbol_tables WHERE "+advanced_query
    puts "\n\n***********************************\n\n"+advanced_query+"\n\n**********************\n\n"

    parameter_search_text=search_text.split.join(" ")
    keyword_array=parameter_search_text.split(' ')
    keyword_count=keyword_array.size

    connection = ActiveRecord::Base.connection();
    if all != "" or exact != "" or any != "" or none != ""
      @resultset = connection.execute("#{advanced_query}");
    else
      @resultset = connection.execute("call keyword_search('#{parameter_search_text}',#{keyword_count})");
    end
    ActiveRecord::Base.clear_active_connections!()

    @resultset.each do |res|
      puts res
    end
    @resultset_strings = @resultset.map { |result| result.to_s.gsub(/[^0-9A-Za-z]/, '')}
    @model_ids=Array.new
    @model_names=Array.new
    @model_types=Array.new
    @resultset_strings.each do |result|
      substring=result[0..4]
      puts"\n\n************"+substring
      if substring ==  "NMLCL"
        cell=Cell.find_by_Cell_ID(result.to_s)
        name=cell.Cell_Name
        type="Cell"
      end

      if substring == "NMLCH"
        channel=Channel.find_by_Channel_ID(result.to_s)
        name=channel.Channel_Name
        type="Channel"
      end


      if substring == "NMLNT"
        network=Network.find_by_Network_ID(result.to_s)
        name=network.Network_Name
        type="Network"
      end

#if substring == "NMLSY"
#name=Synapse.find_by_Synapse_ID(result.to_s)
#type="Syanpse"
#end

      @model_ids.push(result)
      @model_names.push(name)
      @model_types.push(type)
      puts "result-"+result+"name-"+name.to_s
    end

    if @model_ids.count != 0
      render :partial => 'keyword_results_list',:locals => {:model_ids => @model_ids,:model_names => @model_names,:model_types => @model_types}
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
