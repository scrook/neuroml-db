class AuthorListAssociation < ActiveRecord::Base
  attr_accessible :Comments, :AuthorList_ID, :Person_ID ,:is_translator
  self.primary_key = "AuthorList_ID,Person_ID"
end
