class AuthorListAssociation < ActiveRecord::Base
  has_one :Person, foreign_key: "Person_ID"
  attr_accessible :ID, :Comments, :AuthorList_ID, :Person_ID ,:is_translator, :author_sequence
  self.primary_key = "ID"
end
