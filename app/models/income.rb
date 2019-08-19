class Income < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :account

  validates :amount, presence: true, numericality: true
  validates :payment_at, presence: true
end
