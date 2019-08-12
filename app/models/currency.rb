class Currency < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :symbol, presence: true
end
