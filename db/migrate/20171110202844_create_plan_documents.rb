class CreatePlanDocuments < ActiveRecord::Migration
  def change
    create_table :plan_documents do |t|
      t.integer :plan_id, null: false
      t.boolean :is_current, null: false, default: false

      t.timestamps
    end
  end
end
