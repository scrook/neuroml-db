class Synapse < ActiveRecord::Base
include Redmine::SafeAttributes 
 attr_accessible :Synapse_ID, :Synapse_Name, :Comments, :Synapse_File, :Upload_Time
  self.primary_key='Synapse_ID'
end
