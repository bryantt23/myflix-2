class Video < ActiveRecord::Base
  has_many :videos_categories
  has_many :categories, :through => :videos_categories
end