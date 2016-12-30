class AddAsi < ActiveRecord::Migration
  def up
    add_column :plans, :description, :text
    add_column :plans, :code, :string
    add_column :plans, :link_id, :integer
    add_column :plans, :link_type, :string
  end

  def down
    remove_column :plans, :description
    remove_column :plans, :code
    remove_column :plans, :link_id
    remove_column :plans, :link_type
  end
end
