class Video < ActiveRecord::Base
  has_many :videos_categories
  has_many :categories, through: :videos_categories
  has_many :user_reviews, order: "created_at DESC"
  has_many :queue_items

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_terms)
    if search_terms == ""
      []
    else
      Video.where("title LIKE ?", "%#{search_terms}%")
    end
  end

  def average_rating
    total_ratings = []
    user_reviews.each do |review|
      total_ratings << review.rating
    end
    total_ratings = total_ratings.inject(:+)
    avg_rating = total_ratings.to_f / user_reviews.count.to_f
    avg_rating.nan? ? "Rate this video!" : avg_rating
  end
end