class AddUsersTable < ActiveRecord::Migration
  def change
    create_table :users, primary_key: :user_id do |t|
      t.string :user_name, null: false
 
      t.timestamps
    end
  end
end
