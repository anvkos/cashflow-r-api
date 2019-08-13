require 'rails_helper'

RSpec.describe 'Accounts API' do
  describe "POST /accounts" do
    let!(:user) { create(:user) }
    let!(:currency) { create(:currency) }
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
        post '/api/v1/accounts', params: params
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post_with_token '/api/v1/accounts', params, 'invalid_token'
        expect(response.status).to eq 401
      end

      it 'does not save the account' do
        expect { post_with_token '/api/v1/accounts', params, 'invalid_token' }.not_to change(Account, :count)
      end
    end

    context 'authorized' do
      let!(:token) { auth_user(user) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post_with_token '/api/v1/accounts', params, token
          expect(response).to have_http_status(:created)
        end

        it 'returns a account json schema' do
          post_with_token '/api/v1/accounts', params, token
          expect(response).to match_response_schema('v1/accounts/account')
        end

        it 'saves new account in the database' do
          expect { post_with_token '/api/v1/accounts', params, token }.to change(Account, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) { { account: attributes_for(:invalid_account), format: :json } }

        it 'returns 422 status code' do
          post_with_token '/api/v1/accounts', invalid_params, token
          expect(response.status).to eq 422
        end

        it 'does not save the account' do
          expect { post_with_token '/api/v1/accounts', invalid_params, token }.not_to change(Account, :count)
        end
      end
    end
  end
end
