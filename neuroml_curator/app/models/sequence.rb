class Sequence < ActiveRecord::Base
 attr_accessible :Seq_Nbr, :Attr_Name
  self.primary_key='Attr_Name'
end
