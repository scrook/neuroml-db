class Publication < ActiveRecord::Base
  attr_accessible :Comments, :Full_Title, :Publication_ID, :Pubmed_Ref
  set_primary_key :Publication_ID
end
