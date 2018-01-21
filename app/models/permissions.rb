# == Schema Information
#
# Table name: permissions
#
#  id                   :integer          not null, primary key
#  authenticatable_id   :integer
#  authenticatable_type :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Permissions < ActiveRecord::Base
  belongs_to :authenticatable, polymorphic: true
  has_many :job_permissions

  validates :authenticatable_id, :authenticatable_type, presence: true

  def find_or_create_job_permission(job)
    return nil if job.nil?

    job_permission = JobPermission.where(
      job_id: job.id, permissions_id: self.id
    ).first

    if job_permission.nil?
      job_permission = JobPermission.create(
        job_id: job.id, permissions_id: self.id
      )
    end

    return job_permission
  end

  # See spec for permissions_hash structure
  def update_permissions(permissions_hash)
    permissions_hash = permissions_hash || {}
    permissions_hash_for_jobs = permissions_hash[:jobs] || {}

    self.job_permissions.each do |job_permission|
      # Remove the job permission if is nil
      job_permission.destroy if permissions_hash_for_jobs[job_permission.job.id].nil?
    end

    success = true

    permissions_hash_for_jobs.each do |job_id, job_permissions_hash|
      job_permission = JobPermission.where(
        job_id: job_id,
        permissions_id: self.id
      ).first

      if job_permission.nil?
        job_permission = JobPermission.create(job_id: job_id, permissions_id: self.id)
      end

      success = success && job_permission.update_permissions(job_permissions_hash)
    end

    self.reload

    return success
  end
end
