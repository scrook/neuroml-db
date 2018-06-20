class ModelsController < ApplicationController
  caches_action :robots

  def all
    render :json => Model.GetAllModels(), :content_type => 'application/javascript'
  end

  def detail

    result = Model.GetModelDetails(params[:id])

    if result != nil
      render :json => result, :content_type => 'application/javascript', :status => 200
    else
      render :json => "Model not found", :content_type => 'application/javascript', :status => 404
    end

  end

  def waveform

    begin
      result = Model.GetModelWaveForm(params[:id])
      render :json => result, :content_type => 'application/javascript', :status => 200
    rescue
      render :json => "Waveform not in DB or not in file system", :content_type => 'application/javascript', :status => 404
    end

  end

  def plot_waveforms

    begin
      result = Model.GetModelPlotWaveForms(params[:model_id], params[:protocol_id], params[:meta_protocol_id])
      render :json => result, :content_type => 'application/javascript', :status => 200
    rescue
      render :json => "One of the model protocol waveforms is not in DB or not in file system", :content_type => 'application/javascript', :status => 404
    end

  end

  def morphometrics

    result = Model.GetMorphometrics(params[:id])

    if result != nil
      render :json => result, :content_type => 'application/javascript', :status => 200
    else
      render :json => "Model not found", :content_type => 'application/javascript', :status => 404
    end

  end

  def gif

    path = Model.GetModelGifPath(params[:id])

    if path != nil
      send_file path, :type => 'image/gif', :disposition => 'inline'
    else
      render :json => "Model not found", :content_type => 'application/javascript', :status => 404
    end

  end

  def search

    result = Model.SearchKeyword(params[:q].to_s)

    if result != nil
      render :json => result, :content_type => 'application/javascript', :status => 200
    else
      render :json => "No search results", :content_type => 'application/javascript', :status => 404
    end

  end



  def GetModelZip

    modelID =params[:modelID].to_s

    send_data(File.read(Model.GetModelZipFilePath(modelID)), :type => 'application/zip', :filename => modelID + '.zip')

  end

  def GetModelGif

    modelID = params[:modelID].to_s
    gifPath = '/var/www/NeuroMLmodels/' + modelID + '/morphology/model.gif'

    send_data(File.read(gifPath), :type => 'image/gif')

  end

  def GetChannelLEMSZip

    modelID =params[:modelID].to_s

    send_data(File.read(Model.GetChannelLEMSZipFilePath(modelID)), :type => 'application/zip', :filename => modelID + '.zip')

  end



end
