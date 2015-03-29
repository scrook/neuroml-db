class Reference < ActiveRecord::Base
  attr_accessible :Comments, :Reference_ID, :Reference_Resource, :Reference_URI
  set_primary_key "Reference_ID"
end
