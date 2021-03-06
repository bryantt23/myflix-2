class Video < ActiveRecord::Base
  has_many :videos_categories
  has_many :categories, through: :videos_categories
  has_many :user_reviews, order: "created_at DESC"
  has_many :queue_items, order: "order_id ASC"

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_terms)
    if search_terms == ""
      []
    else
      Video.where("title LIKE ?", "%#{search_terms}%")
    end
  end
end