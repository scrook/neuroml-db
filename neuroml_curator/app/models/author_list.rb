class AuthorList < ActiveRecord::Base
  attr_accessible  :AuthorList_ID
  has_many  :author_list_associations
  has_many :persons, :through => :author_list_associations, :foreign_key => "AuthorList_ID"
  self.primary_key = "AuthorList_ID"
end

