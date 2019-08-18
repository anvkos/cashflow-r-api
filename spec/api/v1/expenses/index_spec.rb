require 'rails_helper'

RSpec.describe 'Expenses API' do
  describe "GET /api/v1/expenses" do
    let!(:user) { create(:user) }
    let!(:expenses) { create_list(:expense, 2, user: user) }

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
      let!(:token) { auth_user(user) }

      it "returns http success" do
        get_with_token('/api/v1/expenses', { format: :json }, token)
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of expenses' do
        get_with_token('/api/v1/expenses', { format: :json }, token)
        expect(response.body).to have_json_size(2).at_path('expenses')
      end

      it 'returns expenses json schema' do
        get_with_token('/api/v1/expenses', { format: :json }, token)
        expect(response).to match_response_schema('v1/expenses/expenses')
      end

      it 'does not return another user expenses' do
        other_expense_ids = create_list(:expense, 2).map(&:id)
        get_with_token('/api/v1/expenses', { format: :json }, token)
        data = JSON.parse(response.body)
        data_ids = data["expenses"].map { |item| item["id"] }
        expect(data_ids).not_to include(*other_expense_ids)
      end

      context 'when :start_date and :end_date do not pass' do
        let!(:older_expenses) { create_list(:expense, 2, user: user, payment_at: 1.months.ago) }

        it 'returns current month expenses' do
          expense_ids = expenses.map(&:id)
          get_with_token('/api/v1/expenses', { format: :json }, token)
          data = JSON.parse(response.body)
          data_ids = data["expenses"].map { |item| item["id"] }
          expect(data_ids).to include(*expense_ids)
        end

        it 'does not return expenses for other months' do
          older_expense_ids = older_expenses.map(&:id)
          get_with_token('/api/v1/expenses', { format: :json }, token)
          data = JSON.parse(response.body)
          data_ids = data["expenses"].map { |item| item["id"] }
          expect(data_ids).not_to include(*older_expense_ids)
        end
      end
    end
  end
end
