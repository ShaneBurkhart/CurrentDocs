class InjectShareIdFromPreviousShare < ActiveRecord::Migration
  def up
    Share.all.each do |share|
      share.sharer = share.job.user
      share.errors.full_messages.to_sentence if !share.save
    end
  end

  def down
  end
end
