class RFISerializer < ActiveModel::Serializer
  attributes :id,
    :subject,
    :due_date,
    :assigned_user_id

  has_one :asi
  has_one :assigned_user, serializer: SimpleUserSerializer
end
