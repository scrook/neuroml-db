class NetworkCellAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Network_ID, :Cell_ID
  self.primary_key = "Network_ID,Cell_ID"
end
