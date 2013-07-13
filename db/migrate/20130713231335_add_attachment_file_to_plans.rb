class AddAttachmentFileToPlans < ActiveRecord::Migration
  def change
    add_attachment :plans, :plan
  end
end
