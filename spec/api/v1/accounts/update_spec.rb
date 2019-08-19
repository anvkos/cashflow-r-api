require 'rails_helper'

RSpec.describe 'Accounts API' do
  describe "PATCH /accounts/{:id}" do
    let!(:user) { create(:user) }
    let!(:currency) { create(:currency) }
    let!(:account) { create(:account, user: user, currency: currency) }
    let!(:params) do
      {
        account: {
          currency_id: currency.id,
          name: 'Visa green',
          amount: 1_000_000
        },
        format: :json
      }
    end

    context 'when user is not authenticated' do
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

    context 'when user authenticated' do
      let!(:token) { auth_user(user) }

      context 'when user changes his account' do
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
            expect(account.currency_id).not_to eq invalid_params[:account][:currency_id]
            expect(account.name).not_to eq invalid_params[:account][:name]
            expect(account.amount).not_to eq invalid_params[:account][:amount]
          end
        end
      end

      context 'when user tries to update another user account' do
        let(:other_account) { create(:account) }

        it 'returns 403 status code' do
          patch_with_token "/api/v1/accounts/#{other_account.id}", params, token
          expect(response.status).to eq 403
        end

        it 'does not update expense another user' do
          patch_with_token "/api/v1/accounts/#{other_account.id}", params, token
          %w[currency_id name amount].each do |attribute|
            expect(other_account.reload.send(attribute.to_sym)).not_to eq params[:account][attribute.to_sym]
          end
        end
      end
    end
  end
end
