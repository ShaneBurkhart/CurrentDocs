class RFISerializer < ActiveModel::Serializer
  attributes :id,
    :rfi_num,
    :subject,
    :notes,
    :due_date,
    :assigned_user_id

  has_one :asi
  has_one :user, serializer: SimpleUserSerializer
  has_one :assigned_user, serializer: SimpleUserSerializer
  has_many :attachments, serializer: SimpleAttachmentSerializer
end
