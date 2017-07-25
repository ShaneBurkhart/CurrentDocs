class SubmittalSerializer < ActiveModel::Serializer
  attributes :id, :plan_id, :data, :is_accepted, :created_at
  has_one :user
end
