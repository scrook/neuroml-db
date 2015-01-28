class Kkeyword < ActiveRecord::Base
  attr_accessible :category_id, :keyword_name
  has_many :kcategories
end
