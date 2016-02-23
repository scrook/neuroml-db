class Cell < ActiveRecord::Base
include Redmine::SafeAttributes 
 attr_accessible :Cell_ID, :Cell_Name, :Comments, :MorphML_File, :Upload_Time
  self.primary_key='Cell_ID'
end
