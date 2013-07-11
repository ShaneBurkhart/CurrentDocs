class ShareSerializer < ActiveModel::Serializer
  attributes :id, :accepted
  has_one :user
  embed :ids, include: true
end