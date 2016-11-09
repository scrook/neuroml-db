class Person < ActiveRecord::Base
  belongs_to :AuthorListAssociation, primary_key: "ID"
  attr_accessible :ID, :Person_ID, :Person_First_Name, :Person_Middle_Name, :Person_Last_Name, :Instituition, :Email, :Comments
  self.primary_key = "Person_ID"
end
