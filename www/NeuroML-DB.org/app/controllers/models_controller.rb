class ModelsController < ApplicationController
  caches_action :robots

  def all
    render :json => Model.GetAllModels(), :content_type => 'application/javascript'
  end

  def detail

    result = Model.GetModelDetails(params[:id])

    if result != nil
      render :json => result, :content_type => 'application/javascript', :status => 500
    else
      render :json => "Model not found", :content_type => 'application/javascript', :status => 404
    end

  end

  def GetModelZip

    modelID =params[:modelID].to_s

    send_data(File.read(Model.GetModelZipFilePath(modelID)), :type => 'application/zip', :filename => modelID + '.zip')

  end

  def GetChannelLEMSZip

    modelID =params[:modelID].to_s

    send_data(File.read(Model.GetChannelLEMSZipFilePath(modelID)), :type => 'application/zip', :filename => modelID + '.zip')

  end



end
