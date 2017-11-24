class CreateShareLinks < ActiveRecord::Migration
  def change
    create_table :share_links do |t|
    	t.string :name, null: false
    	t.string :token, null: false
    	t.integer :user_id, null: false
      t.timestamps
    end

    add_index :share_links, :token, unique: true
    add_index :share_links, :user_id
  end
end
