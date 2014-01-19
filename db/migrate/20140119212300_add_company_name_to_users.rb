class AddCompanyNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :string, default: "Company"
  end
end
