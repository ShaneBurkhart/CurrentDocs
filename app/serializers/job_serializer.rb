class JobSerializer < ActiveModel::Serializer
  attributes :id, :name, :archived

  has_many :plans
  has_many :shares
  has_one :user
end
