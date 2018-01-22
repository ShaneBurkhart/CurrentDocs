class AddTeamIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :team, :references
  end
end
