class Publication < ActiveRecord::Base
  attr_accessible :Comments, :Full_Title, :Year, :Publication_ID, :Pubmed_Ref
  self.primary_key = "Publication_ID"
end
