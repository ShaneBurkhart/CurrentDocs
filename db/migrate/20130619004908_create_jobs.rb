class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
    	t.string :name, null: false
    	t.boolean :is_archived, default: false
    	t.integer :user_id, null: false
      t.timestamps
    end

    add_index :jobs, :user_id
    add_index :jobs, :is_archived
  end
end
