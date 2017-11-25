class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :authenticatable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
