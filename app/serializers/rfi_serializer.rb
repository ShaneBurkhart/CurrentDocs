class RFISerializer < ActiveModel::Serializer
  attributes :id,
    :status,
    :subject,
    :plan_sheets_affected,
    :in_addendum,
    :due_date,
    :asi_id,
    :assigned_user_id

  has_one :assigned_user, serializer: SimpleUserSerializer
end
