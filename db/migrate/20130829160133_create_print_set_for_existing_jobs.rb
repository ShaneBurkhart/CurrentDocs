class CreatePrintSetForExistingJobs < ActiveRecord::Migration
  def up
    Job.all.each do |job|
      if !job.print_set
        job.print_set = PrintSet.new job_id: job.id
        job.save
      end
    end
  end

  def down
  end
end
