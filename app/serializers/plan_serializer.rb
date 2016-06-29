class PlanSerializer < ActiveModel::Serializer
  attributes :id, :job_id, :plan_name, :plan_num, :filename, :updated_at,
  		:plan_file_name, :plan, :updated_at, :tab, :csi

  		# Removed plan_updated_at to prevent 500 bug till I can debug
# attributes :id, :job_id, :plan_name, :plan_num, :filename, :updated_at,
# :plan_file_name, :plan, :updated_at, :plan_updated_at, :tab, :csi
end
