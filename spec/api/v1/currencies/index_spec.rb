require 'rails_helper'

RSpec.describe 'Currencies API' do
  describe "GET /api/v1/currencies" do
    before { create_list(:currency, 2) }

    context 'when user is not authenticated' do
      it 'returns 401 status' do
        get '/api/v1/currencies', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get_with_token '/api/v1/currencies', { format: :json }, 'invalid_token'
        expect(response.status).to eq 401
      end
    end

    context 'when user authenticated' do
      let!(:user) { create(:user) }
      let!(:token) { auth_user(user) }

      before { get_with_token('/api/v1/currencies', { format: :json }, token) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of currencies' do
        expect(response.body).to have_json_size(2).at_path('currencies')
      end

      it 'returns currencies json schema' do
        expect(response).to match_response_schema('v1/currencies/currencies')
      end
    end
  end
end
