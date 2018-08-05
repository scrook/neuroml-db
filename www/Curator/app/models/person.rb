class Person < ActiveRecord::Base
  attr_accessible :Person_ID, :Person_First_Name, :Person_Middle_Name, :Person_Last_Name, :Instituition, :Email, :Comments
  belongs_to :author_list_association
  self.primary_key = "Person_ID"
end
