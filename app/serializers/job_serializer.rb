class JobSerializer < ActiveModel::Serializer
  attributes :id, :name, :archived

  has_one :user
  has_many :plans
end
