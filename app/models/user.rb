class User < ActiveRecord::Base
  has_many :user_reviews
  has_many :queue_items, order: :order_id

  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email


  has_secure_password
end