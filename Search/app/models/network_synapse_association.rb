class NetworkSynapseAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Network_ID, :Synapse_ID
  self.primary_key = "Network_ID,Synapse_ID"
end
