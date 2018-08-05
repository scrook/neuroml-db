class ModelModelAssociation < ActiveRecord::Base
  attr_accessible :Parent_ID, :Child_ID
  self.primary_key = "Parent_ID,Child_ID"
end
