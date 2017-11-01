class JobSerializer < ActiveModel::Serializer
  attributes :id, :name, :archived, :subscribed

  has_many :plans
  has_many :rfis
  has_many :submittals
  has_many :shares
  has_one :user
end
