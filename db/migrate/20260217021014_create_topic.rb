class CreateTopic < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0
      t.string :status, default: 'active'
      t.timestamps
    end
  end
end
