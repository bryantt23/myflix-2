class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string  :invited_email
      t.integer :inviter_id

      t.timestamps
    end
  end
end
