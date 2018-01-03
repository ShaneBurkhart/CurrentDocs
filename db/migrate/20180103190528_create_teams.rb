class CreateTeams < ActiveRecord::Migration
  def up
    create_table :teams do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :team_users do |t|
    	t.integer :team_id, null: false
    	t.integer :user_id, null: false
    	t.boolean :is_owner, default: false

      t.timestamps
    end

    add_index :team_users, :team_id
    add_index :team_users, :user_id

    # Link share_links to team
    add_column :share_links, :team_id, :integer
    add_index :share_links, :team_id

    # Link jobs to team
    add_column :jobs, :team_id, :integer
    add_index :jobs, :team_id

    # Migrate each user to their own team
    User.all.each do |user|
      team = Team.create(name: "New Team")

      team_user = TeamUser.new
      team_user.team_id = team.id
      team_user.user_id = user.id
      team_user.save

      user.jobs.each do |job|
        job.team_id = team.id
        job.save
      end

      user.share_links.each do |share_link|
        share_link.team_id = team.id
        share_link.save
      end
    end

    # We only add not null to column after migrating data.
    change_column :share_links, :team_id, :integer, null: false
    change_column :jobs, :team_id, :integer, null: false
  end

  def down
    drop_table :teams
    drop_table :team_users

    remove_column :share_links, :team_id
    remove_column :jobs, :team_id
  end
end
