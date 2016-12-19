class Concentration < ActiveRecord::Base
  include Redmine::SafeAttributes
  attr_accessible :Concentration_ID, :Concentration_Name, :Comments, :Concentration_File, :Upload_Time
  self.primary_key='Concentration_ID'
end
