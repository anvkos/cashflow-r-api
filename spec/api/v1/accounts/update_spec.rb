require 'rails_helper'

RSpec.describe 'Accounts API' do
  describe "PATCH /accounts/{:id}" do
    let!(:user) { create(:user) }
    let!(:currency) { create(:currency) }
    let!(:account) { create(:account, currency: currency) }
    let!(:params) do
      {
        account: {
          currency_id: currency.id,
          name: 'Visa green',
          amount: 1_000_000
        },
        format: :json }
    end

    context 'unauthorized' do
      it 'returns 401 status' do
        patch "/api/v1/accounts/#{account.id}", params: params
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch_with_token "/api/v1/accounts/#{account.id}", params, 'invalid_token'
        expect(response.status).to eq 401
      end

      it 'does not save the account' do
        expect { patch_with_token "/api/v1/accounts/#{account.id}", params, 'invalid_token' }.not_to change(Account, :count)
      end
    end

    context 'authorized' do
      let!(:token) { auth_user(user) }

      context 'user account' do
        context 'with valid attributes' do
          before { patch_with_token "/api/v1/accounts/#{account.id}", params, token }

          it 'returns 200 status code' do
            expect(response.status).to eq 200
          end

          it 'returns a account json schema' do
            expect(response).to match_response_schema('v1/accounts/account')
          end

          it 'updates account attributes' do
            account.reload
            expect(account.currency_id).to eq params[:account][:currency_id]
            expect(account.name).to eq params[:account][:name]
            expect(account.amount).to eq params[:account][:amount]
          end
        end

        context 'with invalid attributes' do
          let(:invalid_params) { { account: attributes_for(:invalid_account), format: :json } }

          before { patch_with_token "/api/v1/accounts/#{account.id}", invalid_params, token }

          it 'returns 422 status code' do
            expect(response.status).to eq 422
          end

          it 'does not change account attributes' do
            account.reload
            expect(account.currency_id).to_not eq invalid_params[:account][:currency_id]
            expect(account.name).to_not eq invalid_params[:account][:name]
            expect(account.amount).to_not eq invalid_params[:account][:amount]
          end
        end
      end

      it 'does not update account another user'
    end
  end
end
