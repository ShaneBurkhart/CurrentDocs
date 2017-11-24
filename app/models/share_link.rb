class ShareLink < ActiveRecord::Base
  attr_accessible :name, :token

  belongs_to :user

  validates :name, :token, :user_id, presence: true
  validate :check_for_duplicate_name_for_user

  before_validation :create_token, unless: :token

  private
    def create_token
      self.token= loop do
        random_token = SecureRandom.urlsafe_base64(20, false)
        break random_token unless ShareLink.exists?(token: random_token)
      end
    end

    def check_for_duplicate_name_for_user
      s = ShareLink.where(user_id: self.user_id, name: self.name)

      if self.id
        s = s.where('id != ?', self.id)
      end

      if s.count != 0
        errors.add(:name, 'already exists')
      end
    end
end
