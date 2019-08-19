require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/signup' }
  let!(:params) do
    {
      email: 'user@example.com',
      password: 'password'
    }
  end

  context 'when a new user is registered' do
    before { post url, params: params }

    it 'returns 201 status code' do
      expect(response.status).to eq 201
    end

    it 'returns a user json schema' do
      expect(response).to match_response_schema('users/user')
    end
  end

  context 'when user already exists' do
    before do
      create(:user, email: params[:email])
      post url, params: params
    end

    it 'returns 422 status code' do
      expect(response.status).to eq 422
    end

    it 'returns validation errors' do
      expect(response.body).to have_json_path('error')
    end
  end
end
