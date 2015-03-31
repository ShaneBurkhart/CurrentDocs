class CreateSignupLinks < ActiveRecord::Migration
  def change
    create_table :signup_links do |t|
      t.string :key
      t.integer :user_id

      t.timestamps
    end

    add_index :signup_links, :user_id
  end
end
