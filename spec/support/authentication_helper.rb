module AuthenticationHelper
  def auth_user(user)
    post user_session_path, params: { user: { email: user.email, password: user.password }, format: :json }
    authorization_token(response)
  end

  def decoded_jwt_token_from_response(response)
    token = authorization_token(response)
    JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true)
  end

  def authorization_token(response)
    response.headers['Authorization'].split(' ').last
  end
end
