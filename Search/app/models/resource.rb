class Resource < ActiveRecord::Base
  attr_accessible :Name, :LogoUrl, :HomePageUrl
  set_primary_key "ID"
end