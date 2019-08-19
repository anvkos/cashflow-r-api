require 'rails_helper'

RSpec.describe 'Accounts API' do
  describe "GET /api/v1/accounts" do
    let!(:user) { create(:user) }
    let!(:accounts) { create_list(:account, 2, user: user) }

    context 'when user is not authenticated' do
      it 'returns 401 status' do
        get '/api/v1/accounts', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get_with_token '/api/v1/accounts', { format: :json }, 'invalid_token'
        expect(response.status).to eq 401
      end
    end

    context 'when user authenticated' do
      let!(:token) { auth_user(user) }

      it "returns http success" do
        get_with_token('/api/v1/accounts', { format: :json }, token)
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of accounts' do
        get_with_token('/api/v1/accounts', { format: :json }, token)
        expect(response.body).to have_json_size(2).at_path('accounts')
      end

      it 'returns accounts json schema' do
        get_with_token('/api/v1/accounts', { format: :json }, token)
        expect(response).to match_response_schema('v1/accounts/accounts')
      end

      context 'when user sees his accounts' do
        let!(:another_user) { create(:user) }
        let!(:another_accounts) { create_list(:account, 2, user: another_user) }

        before { get_with_token('/api/v1/accounts', { format: :json }, token) }

        it 'returns user accounts' do
          account_ids = accounts.map(&:id)
          data = JSON.parse(response.body)
          data_ids = data["accounts"].map { |item| item["id"] }
          expect(data_ids).to include(*account_ids)
        end

        it 'does not return accounts to another user' do
          another_account_ids = another_accounts.map(&:id)
          data = JSON.parse(response.body)
          data_ids = data["accounts"].map { |item| item["id"] }
          expect(data_ids).not_to include(*another_account_ids)
        end
      end
    end
  end
end
