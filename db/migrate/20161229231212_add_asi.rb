class AddASI < ActiveRecord::Migration
  def up
    add_column :plans, :description, :text
    add_column :plans, :code, :string
    add_column :plans, :tags, :string
  end

  def down
    remove_column :plans, :description
    remove_column :plans, :code
    remove_column :plans, :tags
  end
end
