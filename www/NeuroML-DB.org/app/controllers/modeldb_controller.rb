
class ModeldbController < ApplicationController
  caches_action :robots

  def model_list
    render :json => Model.GetAllModelsForModelDB(), :content_type => 'application/javascript'
  end

end
