require 'rails_helper'

RSpec.describe 'Incomes API' do
  describe "GET /api/v1/incomes" do
    let!(:user) { create(:user) }

    let!(:incomes) { create_list(:income, 2, user: user) }

    context 'when user unauthorized' do
      it 'returns 401 status' do
        get '/api/v1/incomes', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get_with_token '/api/v1/incomes', { format: :json }, 'invalid_token'
        expect(response.status).to eq 401
      end
    end

    context 'when user authorized' do
      let!(:token) { auth_user(user) }

      it "returns http success" do
        get_with_token('/api/v1/incomes', { format: :json }, token)
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of incomes' do
        get_with_token('/api/v1/incomes', { format: :json }, token)
        expect(response.body).to have_json_size(2).at_path('incomes')
      end

      it 'returns incomes json schema' do
        get_with_token('/api/v1/incomes', { format: :json }, token)
        expect(response).to match_response_schema('v1/incomes/incomes')
      end

      it 'does not return another user incomes' do
        other_income_ids = create_list(:income, 2).map(&:id)
        get_with_token('/api/v1/incomes', { format: :json }, token)
        data = JSON.parse(response.body)
        data_ids = data["incomes"].map { |item| item["id"] }
        expect(data_ids).not_to include(*other_income_ids)
      end

      context 'with default sorting' do
        it 'returns latest one at first of list' do
          last_id = incomes.last.id
          get_with_token('/api/v1/incomes', { format: :json }, token)
          expect(response.body).to be_json_eql(last_id).at_path("incomes/0/id")
        end
      end
    end
  end
end
