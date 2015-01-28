class Neurolex < ActiveRecord::Base
  attr_accessible :Comments, :NeuroLex_ID, :NeuroLex_Term, :NeuroLex_URI
  self.primary_key='NeuroLex_ID'
end
