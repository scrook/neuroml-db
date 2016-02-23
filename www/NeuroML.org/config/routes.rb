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

RedmineApp::Application.routes.draw do
  root :to => 'welcome#index', :as => 'home'
  match 'home', :to => 'welcome#index', :as => 'home'
  match 'neuromlv2', :to => 'welcome#neuromlv2', :as => 'neuromlv2'
  match 'alpha_schema', :to => 'welcome#alpha_schema' , :as => 'alpha_schema'
  match 'extend_neuroml', :to => 'welcome#extend_neuroml', :as => 'extend_neuroml'
  match 'lems', :to => 'welcome#lems', :as => 'lems'
  match 'relevant_publications', :to => 'welcome#relevant_publications', :as => 'relevant_publications'
  match 'workshops', :to => 'welcome#workshops', :as => 'workshops'
  
  match 'tool_support', :to => 'welcome#tool_support', :as => 'tool_support'
  match 'validate', :to => 'welcome#validate', :as => 'validate'
  match 'neuron_tools', :to => 'welcome#neuron_tools', :as => 'neuron_tools'
  match 'pynn', :to => 'welcome#pynn', :as => 'pynn'
  match 'x3dtools', :to => 'welcome#x3dtools', :as => 'x3dtools'

  match 'browse_models', :to => 'welcome#browse_models', :as => 'browse_models'
  match 'model_submit', :to => 'welcome#model_submit', :as => 'model_submit'
  match 'add_cell', :to => 'welcome#add_cell', :as => 'add_cell'
  match 'add_model', :to => 'welcome#add_model', :as => 'add_model'
  match 'search_result', :to => 'welcome#search_result', :as => 'search_result'
  match 'search_process_test', :to => 'welcome#search_process_test', :as => 'search_process_test'
  match 'search_process', :to => 'welcome#search_process', :as => 'search_process'
  match 'search_python', :to => 'welcome#search_python', :as => 'search_python'
  match 'model_info', :to => 'welcome#model_info', :as => 'model_info'
  match 'submission', :to => 'welcome#submission', :as => 'submission'
  match 'submission_error' , :to => 'welcome#submission_error', :as => 'submission_error'

  match 'history', :to => 'welcome#history', :as => 'history'
  match 'editors', :to => 'welcome#editors', :as => 'editorial_board'
  match 'sitemap', :to => 'welcome#sitemap', :as => 'sitemap'
  match 'scientific_committee', :to => 'welcome#scientific_committee', :as => 'scientific_committee'
  match 'acknowledgements', :to => 'welcome#acknowledgements', :as => 'acknowledgements'
  
  match 'introduction', :to => 'welcome#introduction', :as => 'introduction'
  match 'newsevents', :to => 'welcome#newsevents', :as => 'newsevents'
  match 'workshop2012', :to => 'welcome#workshop2012', :as => 'workshop2012'
  match 'workshop2011', :to => 'welcome#workshop2011', :as => 'workshop2011'
  match 'workshop2010', :to => 'welcome#workshop2010', :as => 'workshop2010'
  match 'workshop2009', :to => 'welcome#workshop2009', :as => 'workshop2009'
  match 'CNS_workshop', :to => 'welcome#CNS_workshop', :as => 'CNS_workshop'
  match 'lems_dev', :to => 'welcome#lems_dev', :as => 'lems_dev'
  match 'mappings', :to => 'welcome#mappings', :as => 'mappings'
  match 'libnml', :to => 'welcome#libnml', :as => 'libnml'
  match 'compatibility', :to => 'welcome#compatibility', :as => 'compatibility'
  match 'specifications', :to => 'welcome#specifications', :as => 'specifications'
  match 'examples', :to => 'welcome#examples', :as => 'examples'
  match 'projects', :to => 'welcome#getneuroml', :as => 'getneuroml'
  match 'getneuroml', :to => 'welcome#getneuroml', :as => 'getneuroml'
end
