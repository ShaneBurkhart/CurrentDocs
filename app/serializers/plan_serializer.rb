class PlanSerializer < ActiveModel::Serializer
  attributes :id,
  :job_id,
  :plan_name,
  :previous_plan_id,
  :next_plan_id,
  :filename,
  :updated_at,
  :plan_file_name,
  :plan,
  :created_at,
  :tab,
  :csi,
  :status,
  :plan_updated_at,
  :description,
  :code,
  :tags
end
