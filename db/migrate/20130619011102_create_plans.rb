class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :page_name
      t.string :filename
      t.integer :job_id

      t.timestamps
    end
  end
end
