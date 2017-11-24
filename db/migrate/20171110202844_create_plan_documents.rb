class CreatePlanDocuments < ActiveRecord::Migration
  def change
    create_table :plan_documents do |t|
      t.integer :plan_id, null: false
      t.boolean :is_current, null: false, default: false

      t.timestamps
    end

    add_index :plan_documents, :is_current
    add_index :plan_documents, :plan_id
  end
end
