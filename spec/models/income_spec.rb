require 'rails_helper'

RSpec.describe Income, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_numericality_of(:amount) }
    it { is_expected.to validate_presence_of :payment_at }
  end

  describe '#latest' do
    subject(:income) { described_class }

    let!(:expected_incomes) do
      [
        create(:income, id: 10, created_at: 10.days.ago),
        create(:income, id: 50, created_at: 5.days.ago)
      ]
    end

    it 'returns latest added incomes first in the list' do
      incomes = income.latest
      expect(incomes.second.id).to eq expected_incomes.first.id
    end
  end
end
