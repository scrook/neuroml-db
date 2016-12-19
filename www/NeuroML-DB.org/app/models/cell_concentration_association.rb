class CellConcentrationAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Concentration_ID, :Cell_ID
  self.primary_key = "Concentration_ID,Cell_ID"
end
