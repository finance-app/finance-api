class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :balance, :comment
end
