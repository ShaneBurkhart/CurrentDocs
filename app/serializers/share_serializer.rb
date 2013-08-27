class ShareSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user
  has_one :sharer
end