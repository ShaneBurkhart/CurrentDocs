class ShareSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user
end