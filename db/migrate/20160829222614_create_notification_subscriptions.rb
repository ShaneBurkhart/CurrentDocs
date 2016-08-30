class CreateNotificationSubscriptions < ActiveRecord::Migration
  def change
    create_table :notification_subscriptions do |t|
      t.integer :user_id
      t.string :target_type
      t.string :target_action
      t.integer :target_id
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :notification_subscriptions, :user_id
    add_index :notification_subscriptions, [:target_type, :target_id] # Create index for 'jobs, 1', then filter based on action
  end
end
