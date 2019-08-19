require 'rails_helper'

RSpec.describe 'POST /login', type: :request do
  let(:user) { create(:user) }
  let(:url) { '/login' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when a user is logging' do
    before { post url, params: params }

    it 'returns 200 status code' do
      expect(response.status).to eq 200
    end

    it 'returns a user json schema' do
      expect(response).to match_response_schema('users/user')
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      decoded_token = decoded_jwt_token_from_response(response)
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }

    it 'returns unathorized status code' do
      expect(response.status).to eq 401
    end
  end
end
