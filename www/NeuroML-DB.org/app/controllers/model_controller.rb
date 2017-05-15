class ModelController < ApplicationController
  caches_action :robots

  def GetModelZip

    modelID =params[:modelID].to_s

    send_data(File.read(Model.GetModelZipFilePath(modelID)), :type => 'application/zip', :filename => modelID + '.zip')

  end

  def GetChannelLEMSZip

    modelID =params[:modelID].to_s

    send_data(File.read(Model.GetChannelLEMSZipFilePath(modelID)), :type => 'application/zip', :filename => modelID + '.zip')

  end



end
