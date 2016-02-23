class CellSynapseAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Synapse_ID, :Cell_ID
  self.primary_key = "Synapse_ID,Cell_ID"
end
