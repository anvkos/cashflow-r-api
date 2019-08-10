require 'rails_helper'

RSpec.describe 'Categories API' do
  describe "GET /api/v1/categories" do
    let!(:categories) { create_list(:category, 2) }

    context 'unauthorized' do
      it 'returns 401 status' do
        get '/api/v1/categories', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get_with_token '/api/v1/categories', { format: :json }, 'invalid_token'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:token) { auth_user(user) }

      before { get_with_token('/api/v1/categories', { format: :json }, token) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of categories' do
        expect(response.body).to have_json_size(2).at_path('categories')
      end

      it 'returns categories json schema' do
        expect(response).to match_response_schema('v1/categories/categories')
      end
    end
  end
end
