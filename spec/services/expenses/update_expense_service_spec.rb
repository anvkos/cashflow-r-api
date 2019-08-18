require 'rails_helper'

RSpec.describe UpdateExpenseService do
  describe '#call' do
    let!(:service) { described_class.new }
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
    let!(:account) { create(:account, user: user) }
    let!(:expense) { create(:expense, user: user) }

    context 'when expense is updated' do
      let(:params) do
        {
          category_id: category.id,
          account_id: account.id,
          amount: 100_000,
          description: 'comment',
          payment_at: 1.days.ago.to_s
        }
      end

      it 'returns expense' do
        expect(service.call(expense, params)).to be_a(Expense)
      end

      it 'changes expense attributes' do
        updated_expense = service.call(expense, params)
        %w[category_id account_id amount description payment_at].each do |attribute|
          expect(updated_expense.send(attribute.to_sym)).to eq params[attribute.to_sym]
        end
      end

      it 'publishes :expense_updated' do
        expect { service.call(expense, params) }.to broadcast(:expense_updated)
      end
    end

    context 'when amount changes' do
      let(:diff_amount) { 5000 }

      it 'user account decreases' do
        params = {
          amount: expense.amount - diff_amount
        }
        prev_amount = expense.account.amount
        service.call(expense, params)
        expect(expense.account.reload.amount).to eq prev_amount + diff_amount
      end

      it 'user account increases' do
        params = {
          amount: expense.amount + diff_amount
        }
        prev_amount = expense.account.amount
        service.call(expense, params)
        expect(expense.account.reload.amount).to eq prev_amount - diff_amount
      end
    end

    context 'when expense is not updated' do
      let(:invalid_params) do
        {
          category_id: nil,
          account_id: nil,
          amount: nil,
          payment_at: 'my_stryng'
        }
      end

      it 'does not change expense attributes' do
        expense.reload
        %w[account_id amount description payment_at].each do |attribute|
          expect(expense.send(attribute.to_sym)).not_to eq invalid_params[attribute.to_sym]
        end
      end

      it 'publishes :expense_error' do
        expect { service.call(expense, invalid_params) }.to broadcast(:expense_error)
      end

      it 'does not change user account' do
        prev_amount = account.amount
        service.call(expense, invalid_params)
        expect(account.reload.amount).to eq prev_amount
      end
    end
  end
end
