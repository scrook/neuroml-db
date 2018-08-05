class Model < ActiveRecord::Base
  attr_accessible :Model_ID
  self.primary_key = "Model_ID"
end
