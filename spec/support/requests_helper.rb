module RequestsHelper
  def get_with_token(path, params = {}, token = '', headers = {})
    headers['Authorization'] = access_token(token)
    get path, params: params, headers: headers
  end

  def post_with_token(path, params = {}, token = '', headers = {})
    headers['Authorization'] = access_token(token)
    post path, params: params, headers: headers
  end

  def patch_with_token(path, params = {}, token = '', headers = {})
    headers['Authorization'] = access_token(token)
    patch path, params: params, headers: headers
  end

  def access_token(token)
    "Bearer #{token}"
  end
end
