class CreateUserReviews < ActiveRecord::Migration
  def change
    create_table :user_reviews do |t|
      t.integer :user_id
      t.integer :video_id
      t.integer :rating
      t.text    :body
      t.timestamps
    end
  end
end
