RedmineApp::Application.routes.draw do
  root :to => 'welcome#search_model', :as => 'search_model'
  match 'home_db', :to => 'welcome#home_db', :as => 'home_db'
  match 'about', :to => 'welcome#home_db', :as => 'home_db'
  match 'gallery', :to => 'welcome#gallery', :as => 'gallery'
  match 'documentation', :to => 'welcome#documentation', :as => 'documentation'
  match 'tool_support', :to => 'welcome#tool_support', :as => 'tool_support'
  match 'search_model', :to => 'welcome#search_model', :as => 'search_model'
  match 'search_python', :to => 'welcome#search_python', :as => 'search_python'
  match 'search_process', :to => 'welcome#search_process', :as => 'search_process'
  match 'model_info', :to => 'welcome#model_info', :as => 'model_info'

  match 'model_submit', :to => 'welcome#model_submit', :as => 'model_submit'
  match 'submission', :to => 'welcome#submission', :as => 'submission'
  match 'submission_error' , :to => 'welcome#submission_error', :as => 'submission_error'

  match 'search_process_test', :to => 'welcome#search_process_test', :as => 'search_process_test'
  match 'search_test', :to => 'welcome#search_test', :as => 'search_test'
  match 'performance_test', :to => 'testing#performance_test', :as => 'performance_test'

  match 'modeldb_model_list', :to => 'modeldb#model_list', :as => 'model_list'
  match 'render_xml_file', :to => 'xml#render_xml_file', :as => 'render_xml_file'
  match 'render_xml_as_html', :to => 'xml#render_xml_as_html', :as => 'render_xml_as_html'

  match 'GetModelVersions', :to => 'models#GetModelVersions', :as => 'GetModelVersions'
  match 'GetModelZip', :to => 'models#GetModelZip', :as => 'GetModelZip'

  match '/api', :to => 'welcome#api'
  match '/api/models', :to => 'models#all'
  match '/api/model', :to => 'models#detail'
  match '/api/models_for_modeldb', :to => 'modeldb#model_list'
  match '/api/waveform', :to => 'models#waveform'
  match '/api/plot_waveforms', :to => 'models#plot_waveforms'
  match '/api/search', :to => 'models#search'
  match '/api/morphometrics', :to => 'models#morphometrics'
  match '/api/gif', :to => 'models#gif'


end
