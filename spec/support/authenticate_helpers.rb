module AuthenticationHelper
  def decoded_jwt_token_from_response(response)
    token = response.headers['Authorization'].split(' ').last
    JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true)
  end
end
