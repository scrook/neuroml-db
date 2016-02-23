class CellChannelAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Cell_ID, :Channel_ID
  self.primary_key = "Cell_ID,Channel_ID"
end
