class Kcategory < ActiveRecord::Base
  attr_accessible :category_name
  belongs_to :kkeywords
end
