class Account < ApplicationRecord
  belongs_to :user
  belongs_to :currency

  validates :name, presence: true
  validates :amount, presence: true, numericality: true
end
