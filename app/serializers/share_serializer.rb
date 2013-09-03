class ShareSerializer < ActiveModel::Serializer
  attributes :id, :can_reshare, :job_id
  has_one :user
  has_one :sharer
end