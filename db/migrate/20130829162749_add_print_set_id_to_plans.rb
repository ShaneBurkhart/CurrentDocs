class AddPrintSetIdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :print_set_id, :integer
  end
end
