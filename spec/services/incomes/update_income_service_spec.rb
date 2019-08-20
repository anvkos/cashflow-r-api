require 'rails_helper'

RSpec.describe UpdateIncomeService do
  describe '#call' do
    let!(:service) { described_class.new }
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
    let!(:account) { create(:account, user: user) }
    let!(:income) { create(:income, user: user, account: account) }

    describe 'income is updated' do
      let(:params) do
        {
          category_id: category.id,
          account_id: account.id,
          amount: 100_000,
          description: 'comment',
          payment_at: 1.days.ago.to_s
        }
      end

      it 'returns income' do
        expect(service.call(income, params)).to be_a(Income)
      end

      it 'changes income attributes' do
        updated_income = service.call(income, params)
        %w[category_id account_id amount description payment_at].each do |attribute|
          expect(updated_income.send(attribute.to_sym)).to eq params[attribute.to_sym]
        end
      end

      it 'publishes :income_updated' do
        expect { service.call(income, params) }.to broadcast(:income_updated)
      end

      context 'when income amount changes' do
        let(:diff_amount) { 5000 }

        it 'user account decreases' do
          params = {
            amount: income.amount - diff_amount
          }
          prev_amount = income.account.amount
          service.call(income, params)
          expect(income.account.reload.amount).to eq prev_amount - diff_amount
        end

        it 'user account increases' do
          params = {
            amount: income.amount + diff_amount
          }
          prev_amount = income.account.amount
          service.call(income, params)
          expect(income.account.reload.amount).to eq prev_amount + diff_amount
        end
      end

      context 'when income account changes' do
        let!(:another_account) { create(:account, user: user) }
        let(:diff_amount) { 5000 }
        let(:params) do
          {
            account_id: another_account.id
          }
        end

        it 'previous income account decreases' do
          prev_account_amount = income.account.amount
          prev_income_amount = income.amount
          service.call(income, params)
          expect(account.reload.amount).to eq prev_account_amount - prev_income_amount
        end

        it 'user account increases' do
          prev_amount = another_account.amount
          service.call(income, params)
          expect(another_account.reload.amount).to eq prev_amount + income.amount
        end
      end
    end

    describe 'income is not updated' do
      let(:invalid_params) do
        {
          category_id: nil,
          account_id: nil,
          amount: nil,
          payment_at: 'my_stryng'
        }
      end

      it 'does not change income attributes' do
        income.reload
        %w[account_id amount description payment_at].each do |attribute|
          expect(income.send(attribute.to_sym)).not_to eq invalid_params[attribute.to_sym]
        end
      end

      it 'publishes :income_error' do
        expect { service.call(income, invalid_params) }.to broadcast(:income_error)
      end

      it 'does not change user account' do
        prev_amount = account.amount
        service.call(income, invalid_params)
        expect(account.reload.amount).to eq prev_amount
      end
    end
  end
end
