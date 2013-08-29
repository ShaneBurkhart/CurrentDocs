class PrintSetSerializer < ActiveModel::Serializer
  attributes :id
  embed :ids, include: false
end
