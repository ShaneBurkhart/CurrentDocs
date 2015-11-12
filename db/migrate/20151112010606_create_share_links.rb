class CreateShareLinks < ActiveRecord::Migration
  def change
    create_table :share_links do |t|
    	t.string :token
    	t.integer :user_id
    	t.integer :company_name
      t.timestamps
    end
  end
end
