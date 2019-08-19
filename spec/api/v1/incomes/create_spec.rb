require 'rails_helper'

RSpec.describe 'Incomes API' do
  describe "POST /incomes" do
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
    let!(:account) { create(:account, user: user) }
    let!(:params) do
      {
        income: {
          category_id: category.id,
          account_id: account.id,
          amount: 100_000,
          description: 'comment',
          payment_at: Time.now.to_s
        },
        format: :json
      }
    end

    context 'when user unauthorized' do
      it 'returns 401 status' do
        post '/api/v1/incomes', params: params
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post_with_token '/api/v1/incomes', params, 'invalid_token'
        expect(response.status).to eq 401
      end

      it 'does not save the income' do
        expect { post_with_token '/api/v1/incomes', params, 'invalid_token' }.not_to change(Income, :count)
      end
    end

    context 'when user authorized' do
      let!(:token) { auth_user(user) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post_with_token '/api/v1/incomes', params, token
          expect(response).to have_http_status(:created)
        end

        it 'returns a income json schema' do
          post_with_token '/api/v1/incomes', params, token
          expect(response).to match_response_schema('v1/incomes/income')
        end

        it 'saves new income in the database' do
          expect { post_with_token '/api/v1/incomes', params, token }.to change(Income, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) { { income: attributes_for(:invalid_income), format: :json } }

        it 'returns 422 status code' do
          post_with_token '/api/v1/incomes', invalid_params, token
          expect(response.status).to eq 422
        end

        it 'does not save the income' do
          expect { post_with_token '/api/v1/incomes', invalid_params, token }.not_to change(Income, :count)
        end
      end
    end
  end
end
