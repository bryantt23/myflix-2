class User < ActiveRecord::Base
  attr_accessible :email, :password, :full_name
  validates_presence_of :email, :full_name
  validates :password, presence: true, on: :create, length: { minimum: 6 }
end