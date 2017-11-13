class AddDescriptionToASIAttachments < ActiveRecord::Migration
  def change
    add_column :asi_attachments, :description, :string
  end
end
