class Category < ActiveRecord::Base
  belongs_to :video
  has_many :videos_categories
  has_many :videos, :through => :videos_categories
end