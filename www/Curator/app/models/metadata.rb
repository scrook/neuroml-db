class Metadata < ActiveRecord::Base
  attr_accessible :Metadata_ID
  set_primary_key "Metadata_ID"
  set_table_name "metadatas"
end

