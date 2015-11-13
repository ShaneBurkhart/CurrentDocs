class ChangeCompanyNameToAStringInShareLinks < ActiveRecord::Migration
    # This is weird but I messed up the migration.  I changed an already ran migration
    # and now the db doesn't match the migrations.  So I just have a placeholder migration
    # that changes the column to what it should be on both up and down.
  def up
      change_column :share_links, :company_name, :string
  end

  def down
      change_column :share_links, :company_name, :string
  end
end
