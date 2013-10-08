require '../../lib/tokenable'

class Invite < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: 'User'

  validates_presence_of :invited_email, :message, :invited_name
end