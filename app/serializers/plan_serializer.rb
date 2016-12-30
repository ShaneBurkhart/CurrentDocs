class PlanSerializer < ActiveModel::Serializer
  attributes :id, :job_id, :plan_name, :plan_num, :filename, :updated_at,
  		:plan_file_name, :plan, :updated_at, :tab, :csi, :status, :plan_updated_at,
      :description, :code, :link_id, :link_type
end
