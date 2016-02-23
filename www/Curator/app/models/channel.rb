class Channel < ActiveRecord::Base
include Redmine::SafeAttributes  
attr_accessible :ChannelML_File, :Channel_ID, :Channel_Name, :Comments, :Upload_Time
  set_primary_key :Channel_ID
end
