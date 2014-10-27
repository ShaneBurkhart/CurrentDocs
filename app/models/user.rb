# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  type                   :string(255)
#  authentication_token   :string(255)
#

class User < ActiveRecord::Base

  has_many :jobs
  has_many :shares
  has_many :shared_jobs, through: :shares, source: :job
  has_many :user_contact_connection, class_name: "Contact", foreign_key: "user_id"
  has_many :contacts, through: :user_contact_connection

  # Include default devise modules. Others available are:
  # , :confirmable,
  # :lockable, :timeoutable and :omniauthable :confirmable,:invitable,
  # :token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password,
   :password_confirmation, :remember_me, :guest, :company, :authentication_token

  validates :authentication_token, :first_name, :last_name, :company, presence: true
  validate :check_type

  before_destroy :destroy_shares
  before_destroy :destroy_jobs

  before_validation :generate_token
  before_validation :ensure_type

  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def self.sorted_by(sort_attr)
    if sort_attr == "created_at" || sort_attr == "last_seen"
      @users = User.order "#{sort_attr} DESC"
    elsif sort_attr == "company"
      @users = User.all.sort { |x, y| x.company.downcase <=> y.company.downcase }
    elsif sort_attr == "name"
      @users = User.all.sort { |x, y| x.full_name.downcase <=> y.full_name.downcase }
    elsif sort_attr == "email"
      @users = User.all.sort { |x, y|
        x.email.downcase.split("@").reverse.join("") <=> y.email.downcase.split("@").reverse.join("")
      }
    else
      @users = User.all.sort_by { |x| 3 - x.sort_param }
    end
  end

  def self.new_guest_user(share_param, pass)
    Viewer.new first_name: "New", last_name: "User",
      email: share_param["email"],
      password: pass, password_confirmation: pass
  end

  def send_share_notification(share)
    UserMailer.share_notification(share).deliver
  end

  def send_new_guest_user_notification(user, pass, parent_email)
    UserMailer.guest_user_notification(user, pass, parent_email).deliver
  end

  def send_message(from_email, message)
    UserMailer.arbitrary_message(from_email, self, message).deliver
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def manager?
  	self.class == Manager
  end

  def viewer?
  	self.class == Viewer
  end

  def admin?
    self.class == Admin
  end

  def has_type?
    return self.type == "Viewer" || self.type == "Manager"
  end

  def is_my_token(token)
    share = Share.find_by_token(token)
    return !share.nil? || is_my_share(share)
  end

  def can_share_job job
    return true if is_my_job job
    share = Share.find_by_job_id_and_user_id job.id, self.id
    return false if share.nil?
    return true if share.can_reshare
  end

  def is_my_job(job)
    job.user.id == self.id
  end

  def is_my_plan(plan)
    is_my_job plan.job
  end

  def is_my_share(share)
    is_being_shared(share) || is_my_job(share.job)
  end

  def is_being_shared(share)
    share.user.id == self.id
  end

  def is_shared_job(job)
    self.shared_jobs.each do |j|
      return true unless j != job
    end
    false
  end

  def is_shared_plan(plan)
    is_shared_job plan.job
  end

  def self.avatar_url email
    hash = Digest::MD5.hexdigest(email.strip)
    "http://www.gravatar.com/avatar/#{hash}?s=200&d=mm"
  end

  def expire # Account has expired so we will set expired flag to true
    if self.cancelled
      self.cancelled = false
      self.type = "Viewer"
    else
      self.expired = true
    end
    self.save
  end

  def sort_param
    return 0 if self.type.nil?
    return 1 if self.viewer?
    return 2 if self.manager?
    return 3 if self.admin?
    return 0
  end

  private

    def generate_token
      self.authentication_token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(authentication_token: random_token)
      end
    end

    def destroy_shares
      Share.where("user_id = ? OR sharer_id = ?", self.id, self.id).destroy_all
    end

    def destroy_jobs
      self.jobs.each do |job|
        job.destroy
      end
    end

    def ensure_type
      self.type = "Viewer" if self.type.nil?
    end

    def check_type
      errors.add(:type, 'Not a valid type') unless self.type == "Admin" || self.type == "Manager" || self.type == "Viewer"
    end
end
