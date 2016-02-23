class Network < ActiveRecord::Base
include Redmine::SafeAttributes  
attr_accessible :Comments, :NetworkML_File, :Network_ID, :Network_Name, :Upload_Time
  self.primary_key='Network_ID'
end
