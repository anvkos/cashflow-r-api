require 'rails_helper'

RSpec.describe 'Incomes API' do
  describe "PATCH /incomes/{:id}" do
    let!(:user) { create(:user) }
    let!(:account) { create(:account, user: user) }
    let!(:income) { create(:income, account: account, user: user) }
    let!(:params) do
      {
        income: {
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
        patch "/api/v1/incomes/#{income.id}", params: params
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch_with_token "/api/v1/incomes/#{income.id}", params, 'invalid_token'
        expect(response.status).to eq 401
      end

      it 'does not save the income' do
        expect { patch_with_token "/api/v1/incomes/#{income.id}", params, 'invalid_token' }.not_to change(Income, :count)
      end
    end

    context 'when user authenticated' do
      let!(:token) { auth_user(user) }

      context 'when the user changes his income' do
        context 'with valid attributes' do
          before { patch_with_token "/api/v1/incomes/#{income.id}", params, token }

          it 'returns 200 status code' do
            expect(response.status).to eq 200
          end

          it 'returns a income json schema' do
            expect(response).to match_response_schema('v1/incomes/income')
          end

          it 'updates income attributes' do
            income.reload
            %w[account_id amount description payment_at].each do |attribute|
              expect(income.send(attribute.to_sym)).to eq params[:income][attribute.to_sym]
            end
            expect(income.amount).to eq params[:income][:amount]
          end
        end

        context 'with invalid attributes' do
          let(:invalid_params) { { income: attributes_for(:invalid_income), format: :json } }

          before { patch_with_token "/api/v1/incomes/#{income.id}", invalid_params, token }

          it 'returns 422 status code' do
            expect(response.status).to eq 422
          end

          it 'does not change income attributes' do
            income.reload
            %w[account_id amount description payment_at].each do |attribute|
              expect(income.send(attribute.to_sym)).not_to eq params[:income][attribute.to_sym]
            end
          end
        end
      end

      context 'when user tries update another user income' do
        let(:other_income) { create(:income) }

        it 'returns 403 status code' do
          patch_with_token "/api/v1/incomes/#{other_income.id}", params, token
          expect(response.status).to eq 403
        end

        it 'does not update income another user' do
          patch_with_token "/api/v1/incomes/#{other_income.id}", params, token
          %w[account_id amount description payment_at].each do |attribute|
            expect(other_income.reload.send(attribute.to_sym)).not_to eq params[:income][attribute.to_sym]
          end
        end
      end
    end
  end
end
