require 'rails_helper'

RSpec.describe CreateExpenseService do
  describe '#call' do
    let!(:service) { described_class.new }
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
    let!(:account) { create(:account) }

    context 'when expense is created' do
      let(:params) do
        {
          category_id: category.id,
          account_id: account.id,
          amount: 100_000,
          description: 'comment',
          payment_at: Time.now.to_s
        }
      end

      it 'save new expense in database' do
        expect { service.call(user, params) }.to change(Expense, :count).by(1)
      end

      it 'returns expense' do
        expect(service.call(user, params)).to be_a(Expense)
      end

      it 'expense has attributes' do
        expense = service.call(user, params)
        %w[category_id account_id amount description payment_at].each do |attribute|
          expect(expense.send(attribute.to_sym)).to eq params[attribute.to_sym]
        end
      end

      it 'publishes :expense_created' do
        expect { service.call(user, params) }.to broadcast(:expense_created)
      end

      context 'when user account decrease' do
        it 'user account decrease' do
          prev_amount = account.amount
          expense = service.call(user, params)
          expect(account.reload.amount).to eq prev_amount - expense.amount
        end
      end
    end

    context 'when expense is not created' do
      let(:invalid_params) do
        {
          category_id: nil,
          account_id: nil,
          amount: nil,
          payment_at: 'my_stryng'
        }
      end

      it 'expense does not save in database' do
        expect { service.call(user, invalid_params) }.not_to change(Expense, :count)
      end

      it 'publishes :expense_error' do
        expect { service.call(user, invalid_params) }.to broadcast(:expense_error)
      end

      it 'does not change user account' do
        prev_amount = account.amount
        service.call(user, invalid_params)
        expect(account.reload.amount).to eq prev_amount
      end
    end
  end
end
