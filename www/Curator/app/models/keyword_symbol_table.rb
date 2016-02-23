class KeywordSymbolTable < ActiveRecord::Base
  attr_accessible :Keyword, :Model_ID
  self.primary_key = "Keyword,Model_ID"
end
