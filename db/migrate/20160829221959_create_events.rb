class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :object_type
      t.integer :object_id
      t.string :object_action

      t.timestamps
    end

    add_index :events, :user_id, :unique => true
    add_index :events, [:object_type, :object_id] # Create index for 'jobs, 1', then filter based on action
  end
end
