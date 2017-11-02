class ASISerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :subject,
    :plan_sheets_affected,
    :in_addendum,
    :rfi_id,
    :assigned_user_id

  has_one :assigned_user, serializer: SimpleUserSerializer
end
