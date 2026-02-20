class CreateTopicComment < ActiveRecord::Migration[8.0]
  def change
    create_table :topic_comments do |t|
      t.integer :topic_id
      t.integer :user_id
      t.integer :parent_id
      t.text :content
      t.integer :likes_count, default: 0
      t.string :status, default: 'active'
      t.timestamps
    end
  end
end
