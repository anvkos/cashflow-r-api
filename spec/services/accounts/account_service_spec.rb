require 'rails_helper'

RSpec.describe AccountService do
  subject(:service) { described_class.new }

  describe '#amount_increase' do
    let!(:account) { create(:account, amount: 1_000) }

    it 'amount account increases' do
      resource = OpenStruct.new(account: account)
      amount = 2
      expected_amount = account.amount + amount
      service.increase_amount(resource, amount)
      expect(account.reload.amount).to eq expected_amount
    end
  end

  describe '#amount_decrease' do
    let!(:account) { create(:account, amount: 1_000) }

    it 'amount account decreases' do
      resource = OpenStruct.new(account: account)
      amount = 2
      expected_amount = account.amount - amount
      service.decrease_amount(resource, amount)
      expect(account.reload.amount).to eq expected_amount
    end
  end
end
