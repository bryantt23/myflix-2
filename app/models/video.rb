class Video < ActiveRecord::Base
  has_many :videos_categories
  has_many :categories, :through => :videos_categories

  validates :title, presence: true
  validates :description, presence: true
end