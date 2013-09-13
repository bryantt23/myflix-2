class CreateMyQueues < ActiveRecord::Migration
  def change
    create_table :my_queues do |t|
      t.integer :user_id
      t.integer :video_id
      t.integer :order
      t.timestamps
    end
  end
end
