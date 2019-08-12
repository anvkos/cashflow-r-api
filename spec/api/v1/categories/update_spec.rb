require 'rails_helper'

RSpec.describe 'Categories API' do
  describe 'PATCH /categories/{:id}' do
    let!(:category) { create(:category) }
    let!(:user) { create(:user) }
    let!(:updated_params) { { category: { name: 'updated name' }, format: :json } }

    context 'unauthorized' do
      it 'returns 401 status' do
        patch "/api/v1/categories/#{category.id}", params: updated_params
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid' do
        patch_with_token "/api/v1/categories/#{category.id}", updated_params, 'invalid_token'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:token) { auth_user(user) }

      context 'with valid attributes' do
        before { patch_with_token "/api/v1/categories/#{category.id}", updated_params, token }

        it 'returns 200 status code' do
          expect(response.status).to eq 200
        end

        it 'returns a category json schema' do
          expect(response).to match_response_schema('v1/categories/category')
        end

        it 'updates category attributes' do
          category.reload
          expect(category.name).to eq updated_params[:category][:name]
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) { { category: attributes_for(:invalid_category), format: :json } }

        before { patch_with_token "/api/v1/categories/#{category.id}", invalid_params, token }

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end

        it 'does not change category attributes' do
          category.reload
          expect(category.name).to_not eq updated_params[:category][:name]
        end
      end
    end
  end
end
