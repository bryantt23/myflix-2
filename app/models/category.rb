class Category < ActiveRecord::Base
  has_many :videos_categories
  has_many :videos, :through => :videos_categories

  def recent_videos
    videos.order("created_at DESC").limit(6)
  end
end