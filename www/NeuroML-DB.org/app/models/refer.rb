class Refer < ActiveRecord::Base
  attr_accessible :Comments, :Reference_ID, :Reference_Resource_ID, :Reference_Resource, :Reference_URI
  self.primary_key = "Reference_ID"
end
