class AddPermissionsColumnToSharesTable < ActiveRecord::Migration
  def change
    add_column :shares, :permissions, :integer, default: 4
  end
end
