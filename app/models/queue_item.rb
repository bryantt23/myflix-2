class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :user_id, :video_id
  validates_numericality_of :order_id, {only_integer: true}
end