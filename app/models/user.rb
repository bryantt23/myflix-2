class User < ActiveRecord::Base
  include Tokenable
  has_many :user_reviews, order: "created_at DESC"
  has_many :queue_items, order: :order_id

  has_many :following_relationships, foreign_key: :follower_id, class_name: "Follow"
  has_many :leading_relationships, foreign_key: :followed_id  , class_name: "Follow"
  has_many :invites

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

  def follows?(another_user)
    following_relationships.map(&:followed).include?(another_user)
  end

  def follow(another_user)
    following_relationships.create(followed: another_user) unless another_user == self
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end