class ContactsIndex < ActiveRecord::Migration
  def up
    add_index :contacts, :user_id
    add_index :contacts, :contact_id
  end

  def down
    remove_index :contacts, :user_id
    remove_index :contacts, :contact_id
  end
end
