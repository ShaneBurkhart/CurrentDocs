class CreateShareLinks < ActiveRecord::Migration
  def change
    create_table :share_links do |t|
    	t.string :token
    	t.integer :job_id
    	t.integer :user_id
    	t.string :email_shared_with
    	t.integer :company_name
      t.timestamps
    end
  end
end
