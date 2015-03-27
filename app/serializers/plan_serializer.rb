class PlanSerializer < ActiveModel::Serializer
  attributes :id, :plan_name, :plan_num, :filename, :updated_at,
  		:plan_file_name, :plan, :job_name, :updated_at,
		:plan_updated_at
  has_one :job
  embed :ids, include: false

  def job_name
    object.job.name
  end
end
