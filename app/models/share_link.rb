class ShareLink < ActiveRecord::Base
  include UserRoles

  attr_accessible :name

  belongs_to :user
  has_one :permissions, as: :authenticatable

  validates :name, :user_id, presence: true
  validate :check_for_duplicate_name_for_user

  before_validation :create_token, unless: :token
  after_save :create_blank_permissions, unless: :permissions

  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def login_url
    url_helpers = Rails.application.routes.url_helpers
    return url_helpers.login_share_link_url(self.token, host: ENV["DOMAIN"])
  end

  def jobs
    permissions_id = self.permissions.id
    job_ids = JobPermission.where(permissions_id: permissions_id).pluck(:job_id)

    return Job.where(id: job_ids || [])
  end

  def open_jobs
    permissions_id = self.permissions.id
    job_ids = JobPermission.where(permissions_id: permissions_id).pluck(:job_id)

    return Job.where(id: job_ids || [], is_archived: false)
  end

  def archived_jobs
    permissions_id = self.permissions.id
    job_ids = JobPermission.where(permissions_id: permissions_id).pluck(:job_id)

    return Job.where(id: job_ids || [], is_archived: true)
  end

  # We are matching User interface with this.
  def share_links
    return nil
  end

  private
    def create_token
      self.token= loop do
        random_token = SecureRandom.urlsafe_base64(20, false)
        break random_token unless ShareLink.exists?(token: random_token)
      end
    end

    def create_blank_permissions
      return if self.permissions

      permissions = Permissions.new
      permissions.authenticatable = self
      permissions.save

      self.reload
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
