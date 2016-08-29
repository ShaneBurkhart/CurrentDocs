class CreateNotificationSubscriptions < ActiveRecord::Migration
  def change
    create_table :notification_subscriptions do |t|
      t.integer :user_id
      t.string :object_type
      t.string :object_action
      t.integer :object_id
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :notification_subscriptions, :user_id, :unique => true
    add_index :notification_subscriptions, [:object_type, :object_id] # Create index for 'jobs, 1', then filter based on action
  end
end
