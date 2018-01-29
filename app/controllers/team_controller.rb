class TeamController < ApplicationController
  before_filter :authenticate_user!

  # TODO(rzendacott) Only allow project admin to view?
  # Shows the team's name and a table of its users.
  # Can add more users or change user roles with #update.
  def show
    @team = Team.includes(:users).find(current_user.team_id)
  end

  def update
    # TODO(rzendacott)
  end
end
