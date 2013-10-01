class User < ActiveRecord::Base
  has_many :user_reviews, order: "created_at DESC"
  has_many :queue_items, order: :order_id

  has_many :follows, foreign_key: "follower_id", class_name: "Follow", dependent: :destroy
  has_many :users_followed, through: :follows, source: :followed
  has_many :inverse_follows, foreign_key: "followed_id", class_name: "Follow", dependent: :destroy
  has_many :users_following, through: :inverse_follows, source: :follower

  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email


  has_secure_password

  def normalize_queue_item_order_id
    counter = 1
    queue_items.each do |queue_item|
      queue_item.update_attributes(order_id: counter)
      counter += 1
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end