class TeamUser < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  validates :team_id, :user_id, presence: true
  validate :check_for_duplicate_user_for_team

  private

    def check_for_duplicate_user_for_team
      users = TeamUser.where(team_id: self.team_id, user_id: self.user_id)

      if self.id
        users = users.where('id != ?', self.id)
      end

      if users.count != 0
        errors.add(:user_id, 'already exists on this team')
      end
    end
end
