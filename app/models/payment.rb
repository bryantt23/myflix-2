class Payment < ActiveRecord::Base
  belongs_to :user

  def to_dollar
    "$#{'%.2f' % (amount / 100.0)}"
  end
end