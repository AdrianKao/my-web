class CreateArticleComments < ActiveRecord::Migration[8.0]
  def change
    create_table :article_comments do |t|
      t.integer :article_id
      t.integer :user_id
      t.integer :parent_id, null: true
      t.text :content
      t.integer :likes_count, default: 0
      t.string :status, default: 'active'
      t.timestamps
    end
  end
end
