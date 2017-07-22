class CreateSubmittals < ActiveRecord::Migration
  def change
    create_table :submittals do |t|
      t.text :data
      t.boolean :is_accepted, default: false
      t.integer :user_id
      t.integer :plan_id

      t.timestamps
    end
  end
end
