class User < ActiveRecord::Base
  has_many :user_reviews
  has_many :my_queues

  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email


  has_secure_password
end