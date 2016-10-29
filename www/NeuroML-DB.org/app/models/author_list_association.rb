class AuthorListAssociation < ActiveRecord::Base
  attr_accessible :Comments, :AuthorList_ID, :Person_ID ,:is_translator, :author_sequence
  self.primary_key = "AuthorList_ID,Person_ID"
end
