class AccountSerializer < ActiveModel::Serializer
  attributes :id, :currency, :name, :amount, :created_at, :updated_at
  belongs_to :currency, serializer: CurrencySerializer
end
