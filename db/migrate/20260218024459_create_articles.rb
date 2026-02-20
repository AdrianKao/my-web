class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      #  status (draft / pending / approved / rejected)
      t.integer :user_id
      t.string :title
      t.text :content
      t.integer :category_id
      t.string :status, default: 'draft'
      t.text :reject_reason
      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end
