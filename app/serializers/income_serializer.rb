class IncomeSerializer < ActiveModel::Serializer
  attributes :id, :category, :currency, :account, :amount, :description, :payment_at, :created_at, :updated_at
  belongs_to :category, serializer: CategorySerializer
  belongs_to :currency, serializer: CurrencySerializer
  belongs_to :account, serializer: AccountPreviewSerializer
end
