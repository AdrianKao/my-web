class CreateReviewLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :review_logs do |t|
      t.integer :reviewer_id
      t.integer :article_id
      t.string :action, limit: 10 # approved / rejected
      t.text :reason
      t.timestamps
    end
  end
end
