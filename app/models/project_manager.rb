class ProjectManager < ActiveRecord::Base
  attr_accessible :job_id, :user_id

  belongs_to :job
  belongs_to :project_manager, class_name: "User", foreign_key: "user_id"
end
