class AddDateSubmittedToASIs < ActiveRecord::Migration
  def change
    add_column :asis, :date_submitted, :datetime
  end
end
