class PlanSerializer < ActiveModel::Serializer
  attributes :id, :plan_name, :plan_num, :filename, :updated_at,
  		:plan_file_name
  has_one :job
  embed :ids, include: false
end
