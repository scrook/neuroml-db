class ExpectedSearchResult < ActiveRecord::Base
  attr_accessible :Query, :ModelID_Keyword, :ModelID_Ontology
  self.primary_key = "ID"
end
