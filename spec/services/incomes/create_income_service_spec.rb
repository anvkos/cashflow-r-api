require 'rails_helper'

RSpec.describe CreateIncomeService do
  describe '#call' do
    let!(:service) { described_class.new }
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
    let!(:account) { create(:account) }

    context 'when income is created' do
      let(:params) do
        {
          category_id: category.id,
          account_id: account.id,
          amount: 100_000,
          description: 'comment',
          payment_at: Time.now.to_s
        }
      end

      it 'save new income in database' do
        expect { service.call(user, params) }.to change(Income, :count).by(1)
      end

      it 'returns income' do
        expect(service.call(user, params)).to be_a(Income)
      end

      it 'income has attributes' do
        income = service.call(user, params)
        %w[category_id account_id amount description payment_at].each do |attribute|
          expect(income.send(attribute.to_sym)).to eq params[attribute.to_sym]
        end
      end

      it 'publishes :income_created' do
        expect { service.call(user, params) }.to broadcast(:income_created)
      end

      context 'when user account changes' do
        it 'user account increases' do
          prev_amount = account.amount
          income = service.call(user, params)
          expect(account.reload.amount).to eq prev_amount + income.amount
        end
      end
    end

    context 'when income is not created' do
      let(:invalid_params) do
        {
          category_id: nil,
          account_id: nil,
          amount: nil,
          payment_at: 'my_stryng'
        }
      end

      it 'income does not save in database' do
        expect { service.call(user, invalid_params) }.not_to change(Income, :count)
      end

      it 'publishes :income_error' do
        expect { service.call(user, invalid_params) }.to broadcast(:income_error)
      end

      it 'does not change user account' do
        prev_amount = account.amount
        service.call(user, invalid_params)
        expect(account.reload.amount).to eq prev_amount
      end
    end
  end
end
