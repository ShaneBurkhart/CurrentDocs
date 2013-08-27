class CreatePrintSets < ActiveRecord::Migration
  def change
    create_table :print_sets do |t|
      t.integer :job_id

      t.timestamps
    end
  end
end
