class CreateLikeRecord < ActiveRecord::Migration[8.0]
  def change
    create_table :like_records do |t|
      t.integer :user_id
      t.string :likeable_type # likeable_type (Article / ArticleComment / Topic / TopicComment)
      t.integer :likeable_id
      t.timestamps
    end
  end
end
