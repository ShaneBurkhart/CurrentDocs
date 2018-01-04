class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :jobs
  has_many :team_users
  has_many :users, through: :team_users
  has_many :share_links

  validates :name, presence: true

  def add_user(user)
    return false if user.nil?
    return true if self.users.include?(user)

    team_user = self.team_users.build
    team_user.user_id = user.id
    team_user.save
  end

  def is_user(user)
    return self.users.include?(user)
  end
end
