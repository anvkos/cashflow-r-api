require 'rails_helper'

RSpec.describe 'Accounts API' do
  describe "GET /api/v1/accounts" do
    let!(:accounts) { create_list(:account, 2) }

    context 'unauthorized' do
      it 'returns 401 status' do
        get '/api/v1/accounts', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get_with_token '/api/v1/accounts', { format: :json }, 'invalid_token'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:token) { auth_user(user) }

      before { get_with_token('/api/v1/accounts', { format: :json }, token) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of accounts' do
        expect(response.body).to have_json_size(2).at_path('accounts')
      end

      it 'returns accounts json schema' do
        expect(response).to match_response_schema('v1/accounts/accounts')
      end
    end
  end
end
