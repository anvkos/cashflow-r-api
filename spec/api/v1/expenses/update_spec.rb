require 'rails_helper'

RSpec.describe 'Expenses API' do
  describe "PATCH /expenses/{:id}" do
    let!(:user) { create(:user) }
    let!(:account) { create(:account, user: user) }
    let!(:expense) { create(:expense, account: account, user: user) }
    let!(:params) do
      {
        expense: {
          category_id: create(:category).id,
          account_id: create(:account, user: user).id,
          amount: 1_789_000,
          description: 'updated comment',
          payment_at: 1.days.ago.to_s
        },
        format: :json
      }
    end

    context 'when user is not authenticated' do
      it 'returns 401 status' do
        patch "/api/v1/expenses/#{expense.id}", params: params
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch_with_token "/api/v1/expenses/#{expense.id}", params, 'invalid_token'
        expect(response.status).to eq 401
      end

      it 'does not save the expense' do
        expect { patch_with_token "/api/v1/expenses/#{expense.id}", params, 'invalid_token' }.not_to change(Expense, :count)
      end
    end

    context 'when user authenticated' do
      let!(:token) { auth_user(user) }

      context 'when the user changes his expense' do
        context 'with valid attributes' do
          before { patch_with_token "/api/v1/expenses/#{expense.id}", params, token }

          it 'returns 200 status code' do
            expect(response.status).to eq 200
          end

          it 'returns a expense json schema' do
            expect(response).to match_response_schema('v1/expenses/expense')
          end

          it 'updates expense attributes' do
            expense.reload
            %w[account_id amount description payment_at].each do |attribute|
              expect(expense.send(attribute.to_sym)).to eq params[:expense][attribute.to_sym]
            end
            expect(expense.amount).to eq params[:expense][:amount]
          end
        end

        context 'with invalid attributes' do
          let(:invalid_params) { { expense: attributes_for(:invalid_expense), format: :json } }

          before { patch_with_token "/api/v1/expenses/#{expense.id}", invalid_params, token }

          it 'returns 422 status code' do
            expect(response.status).to eq 422
          end

          it 'does not change expense attributes' do
            expense.reload
            %w[account_id amount description payment_at].each do |attribute|
              expect(expense.send(attribute.to_sym)).not_to eq params[:expense][attribute.to_sym]
            end
          end
        end
      end

      context 'when user tries update another user expense' do
        let(:other_expense) { create(:expense) }

        it 'returns 403 status code' do
          patch_with_token "/api/v1/expenses/#{other_expense.id}", params, token
          expect(response.status).to eq 403
        end

        it 'does not update expense another user' do
          patch_with_token "/api/v1/expenses/#{other_expense.id}", params, token
          %w[account_id amount description payment_at].each do |attribute|
            expect(other_expense.send(attribute.to_sym)).not_to eq params[:expense][attribute.to_sym]
          end
        end
      end
    end
  end
end
