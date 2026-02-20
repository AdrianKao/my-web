class CreateUser < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true
      t.string :email, null: false, index: true
      t.string :password
      t.timestamps
    end
  end
end
