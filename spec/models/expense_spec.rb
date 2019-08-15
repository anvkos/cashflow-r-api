require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of :amount }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of :payment_at }
  end

  it { should delegate_method(:currency).to(:account) }
end
