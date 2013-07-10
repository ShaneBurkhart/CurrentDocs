class ShareSerializer < ActiveModel::Serializer
  attributes :id, :accepted
  has_one :user
  has_one :job
  embed :ids, include: true
end