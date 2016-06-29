class AddCsi < ActiveRecord::Migration
  def up
  	add_column :plans, :csi, :string
  end

  def down
  	remove_column :plans, :csi
  end
end
