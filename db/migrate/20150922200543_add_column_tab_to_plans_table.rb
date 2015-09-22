class AddColumnTabToPlansTable < ActiveRecord::Migration
  def change
    add_column :plans, :tab, :string, default: "Plans"
  end
end
