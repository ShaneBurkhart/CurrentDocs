class AddSharerIdToShare < ActiveRecord::Migration
  def change
    add_column :shares, :sharer_id, :integer
  end
end
