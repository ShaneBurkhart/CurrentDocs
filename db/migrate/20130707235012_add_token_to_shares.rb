class AddTokenToShares < ActiveRecord::Migration
  def change
    add_column :shares, :token, :string
  end
end
