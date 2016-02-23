class ModelMetadataAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Metadata_ID, :Model_ID
  self.primary_key = "Metadata_ID,Model_ID"
end
