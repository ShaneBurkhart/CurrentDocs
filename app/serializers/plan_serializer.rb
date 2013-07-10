class PlanSerializer < ActiveModel::Serializer
  attributes :id, :plan_name, :plan_num, :filename, :updated_at
  has_on :job
  embed :ids, include: true
end
