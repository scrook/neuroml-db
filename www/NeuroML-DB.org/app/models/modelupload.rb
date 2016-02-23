class Modelupload < ActiveRecord::Base
  attr_accessible :Comments, :Description, :Email, :FirstName, :Institution, :Keywords, :LastName, :MiddleName, :ModelName, :Modelref, :Modelspath, :Publication, :SubmissionID
  self.primary_key = "SubmissionID"
end
