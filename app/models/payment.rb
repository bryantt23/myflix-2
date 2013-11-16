class Payment < ActiveRecord::Base
  belongs_to :user

  def to_dollar
    "$#{'%.2f' % (amount / 100.0)}"
  end

  def self.get_user_payments(user_id)
    Payment.where("user_id LIKE ?", "#{user_id}").order('created_at desc')
  end
end