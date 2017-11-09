class JobSerializer < ActiveModel::Serializer
  attributes :id, :name, :archived, :subscribed

  has_one :project_manager, serializer: SimpleUserSerializer

  has_many :plans
  has_many :unlinked_asis
  has_many :rfis
  has_many :submittals
  has_many :shares
  has_one :user
end
