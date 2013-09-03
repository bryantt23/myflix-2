class Category < ActiveRecord::Base
  has_many :videos_categories
  has_many :videos, :through => :videos_categories
end