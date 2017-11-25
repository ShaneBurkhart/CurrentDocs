class CreateJobPermissions < ActiveRecord::Migration
  def change
    create_table :job_permissions do |t|
      t.integer :job_id, null: false
      t.integer :permissions_id, null: false
      t.boolean :can_update, default: false

      t.timestamps
    end

    add_index :job_permissions, :job_id
    add_index :job_permissions, :permissions_id
  end
end
