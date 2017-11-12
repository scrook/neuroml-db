class OtherKeyword < ActiveRecord::Base
  attr_accessible :Other_Keyword_ID,:Other_Keyword_term,:Comments
  self.primary_key = "Other_Keyword_ID"
end
