class AddConvosTable < ActiveRecord::Migration
  def change
    create_table :convos, primary_key: :convo_id do |t|
      t.integer :thread_convo_id
      t.integer :sender_user_id, null: false
      t.integer :recipient_user_id, null: false
      t.string :subject_line, null: false, limit: 140
      t.text :body, null: false
      t.string :state, default: "new"
 
      t.timestamps
    end

    add_index :convos, :thread_convo_id
  end
end
