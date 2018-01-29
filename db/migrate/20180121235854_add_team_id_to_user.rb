class AddTeamIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :team_id, :integer, references: :teams
    add_index :users, :team_id
  end
end
