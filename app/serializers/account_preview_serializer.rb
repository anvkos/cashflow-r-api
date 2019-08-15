class AccountPreviewSerializer < ActiveModel::Serializer
  attributes :id, :currency_id, :name, :amount
end
