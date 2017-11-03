class RFISerializer < ActiveModel::Serializer
  attributes :id,
    :rfi_num,
    :subject,
    :due_date,
    :assigned_user_id

  has_one :asi
  has_one :user, serializer: SimpleUserSerializer
  has_one :assigned_user, serializer: SimpleUserSerializer
end
