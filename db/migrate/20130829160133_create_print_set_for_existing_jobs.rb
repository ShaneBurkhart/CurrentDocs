class CreatePrintSetForExistingJobs < ActiveRecord::Migration
  def up
    Job.all.each do |job|
      if !job.print_set
        print = PrintSet.new
        print.job_id = job.id
        job.print_set = print
        job.save
      end
    end
  end

  def down
  end
end
