class AddCanReshareToShares < ActiveRecord::Migration
  def change
    add_column :shares, :can_reshare, :boolean, default: false
  end
end