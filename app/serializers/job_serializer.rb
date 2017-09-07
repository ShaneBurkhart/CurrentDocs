class JobSerializer < ActiveModel::Serializer
  attributes :id, :name, :archived, :subscribed

  has_many :plans
  has_many :submittals
  has_many :shares
  has_many :photos
  has_one :user
end
