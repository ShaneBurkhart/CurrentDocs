class CreatePlanDocumentHistories < ActiveRecord::Migration
  def change
    create_table :plan_document_histories do |t|
      t.integer :plan_id, null: false
      t.integer :document_id, null: false, unique: true

      t.timestamps
    end
  end
end
