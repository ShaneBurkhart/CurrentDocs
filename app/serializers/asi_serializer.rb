class ASISerializer < ActiveModel::Serializer
  attributes :id,
    :asi_num,
    :status,
    :subject,
    :notes,
    :plan_sheets_affected,
    :in_addendum,
    :rfi_id,
    :assigned_user_id,
    :updated_at

  has_one :user, serializer: SimpleUserSerializer
  has_one :assigned_user, serializer: SimpleUserSerializer
  has_many :attachments, serializer: SimpleAttachmentSerializer
end
