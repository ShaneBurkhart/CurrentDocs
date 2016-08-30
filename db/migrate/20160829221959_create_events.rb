class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :target_type
      t.integer :target_id
      t.string :target_action

      t.timestamps
    end

    add_index :events, :user_id
    add_index :events, [:target_type, :target_id] # Create index for 'jobs, 1', then filter based on action
  end
end
