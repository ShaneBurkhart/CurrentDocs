class CreatePlanDocuments < ActiveRecord::Migration
  def change
    create_table :plan_documents do |t|
      t.integer :plan_id, null: false, unique: true
      t.integer :document_id, null: false, unique: true

      t.timestamps
    end
  end
end
