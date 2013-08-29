class PrintSetSerializer < ActiveModel::Serializer
  attributes :id
  has_many :plans
  embed :ids, include: false
end
