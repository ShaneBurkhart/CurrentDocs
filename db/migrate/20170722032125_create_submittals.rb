class CreateSubmittals < ActiveRecord::Migration
  def change
    create_table :submittals do |t|
      t.json :data
      t.integer :user_id
      t.integer :plan_id

      t.timestamps
    end
  end
end
