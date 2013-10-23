class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating
    total_ratings = []
    object.user_reviews.each do |review|
      total_ratings << review.rating
    end
    total_ratings = total_ratings.inject(:+)
    avg_rating = total_ratings.to_f / user_reviews.count.to_f
    avg_rating.nan? ? "Rate this video!" : avg_rating
  end
end