class JobSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :plans
  has_many :shares
  has_one :user
  has_one :print_set
end
