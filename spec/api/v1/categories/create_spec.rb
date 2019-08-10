require 'rails_helper'

RSpec.describe 'Categories API' do
  describe "POST /categories" do
    let!(:params) { { category: attributes_for(:category), format: :json } }
    let!(:user) { create(:user) }
    let!(:url) { '/api/v1/categories' }
    let!(:token) { auth_user(user) }

    context 'unauthorized' do
      it 'returns 401 status' do
        post '/api/v1/categories', params: params
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post_with_token '/api/v1/categories', params, 'invalid_token'
        expect(response.status).to eq 401
      end

      it 'does not save the category' do
        expect { post_with_token '/api/v1/categories', params, 'invalid_token' }.not_to change(Category, :count)
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post_with_token '/api/v1/categories', params, token
          expect(response).to have_http_status(:created)
        end

        it 'returns a category json schema' do
          post_with_token '/api/v1/categories', params, token
          expect(response).to match_response_schema('v1/categories/category')
        end

        it 'saves new category in the database' do
          expect { post_with_token '/api/v1/categories', params, token }.to change(Category, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) { { category: attributes_for(:invalid_category), format: :json } }

        it 'returns 422 status code' do
          post_with_token '/api/v1/categories', invalid_params, token
          expect(response.status).to eq 422
        end

        it 'does not save the category' do
          expect { post_with_token '/api/v1/categories', invalid_params, token }.not_to change(Category, :count)
        end
      end
    end
  end
end
