class ShareSerializer < ActiveModel::Serializer
  attributes :id, :can_reshare
  has_one :user
  has_one :sharer
end