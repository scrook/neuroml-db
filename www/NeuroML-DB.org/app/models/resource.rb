class Resource < ActiveRecord::Base
  attr_accessible :Name, :LogoUrl, :HomePageUrl
  self.primary_key = "Resource_ID"
end