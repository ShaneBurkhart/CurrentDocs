class CreatePlanTabPermissions < ActiveRecord::Migration
  def change
    create_table :plan_tab_permissions do |t|
      t.string :tab, null: false
      t.integer :job_permission_id, null: false
      t.boolean :can_create, default: false
      t.boolean :can_edit, default: false
      t.boolean :can_destroy, default: false

      t.timestamps
    end

    add_index :plan_tab_permissions, :job_permission_id
  end
end
