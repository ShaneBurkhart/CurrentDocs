class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :tab, null: false
      t.integer :job_id, null: false
      t.integer :order_num, null: false

      t.timestamps
    end

    add_index :plans, :tab
    add_index :plans, :job_id
    add_index :plans, :order_num
  end
end
