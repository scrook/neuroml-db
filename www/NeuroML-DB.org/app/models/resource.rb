class Resource < ActiveRecord::Base
  attr_accessible :Name, :LogoUrl, :HomePageUrl, :SciCrunch_RRID
  self.primary_key = "Resource_ID"
end