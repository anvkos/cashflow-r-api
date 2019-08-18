require 'rails_helper'

RSpec.describe 'Expenses API' do
  describe "GET /api/v1/expenses" do
    before { create_list(:expense, 2) }

    context 'when user unauthorized' do
      it 'returns 401 status' do
        get '/api/v1/expenses', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get_with_token '/api/v1/expenses', { format: :json }, 'invalid_token'
        expect(response.status).to eq 401
      end
    end

    context 'when user authorized' do
      let!(:user) { create(:user) }
      let!(:token) { auth_user(user) }

      before { get_with_token('/api/v1/expenses', { format: :json }, token) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of expenses' do
        expect(response.body).to have_json_size(2).at_path('expenses')
      end

      it 'returns expenses json schema' do
        expect(response).to match_response_schema('v1/expenses/expenses')
      end
    end
  end
end
