class AuthorList < ActiveRecord::Base
  attr_accessible  :AuthorList_ID
  self.primary_key = "AuthorList_ID"
end

