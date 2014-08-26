class RemovePrintSets < ActiveRecord::Migration
  def up
    drop_table :print_sets
    remove_column :plans, :print_set_id
  end

  def down
    create_table :print_sets do |t|
      t.integer :job_id
      t.timestamps
    end

    add_column :plans, :print_set_id, :integer
  end
end
