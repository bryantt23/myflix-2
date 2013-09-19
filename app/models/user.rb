class User < ActiveRecord::Base
  has_many :user_reviews
  has_many :queue_items, order: :order_id

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
end