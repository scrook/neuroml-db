class NetworkConcentrationAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Network_ID, :Concentration_ID
  self.primary_key = "Network_ID,Concentration_ID"
end
