class RFISerializer < ActiveModel::Serializer
  attributes :status,
    :subject,
    :plan_sheets_affected,
    :in_addendum,
    :due_date,
    :assigned_user_id

  has_one :assigned_user, serializer: SimpleUserSerializer
end
