class CreateVideosCategories < ActiveRecord::Migration
  def up
    create_table :videos_categories do |t|
      t.integer :video_id
      t.integer :category_id

    end
  end

  def down
  end
end
