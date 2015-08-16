require 'base64'

class Token
  include Virtus.value_object(coerce: true)

  values do
    attribute :access_token, String, writer: :private

    attribute :token_type, String, default: 'bearer', writer: :private

    attribute :expires_in, Integer, default: 3600, writer: :private

    attribute :refresh_token, String, writer: :private
  end

  def expires
    expires_in.seconds.from_now
  end

  def refresh!
    response = oauth_service.token(refresh_params, { method: :post }).call.body
    self.access_token = response.access_token
    self.token_type = response.token_type
    self.expires_in = response.expires_in
    self.refresh_token = response.refresh_token
    response
  end

  def logout!
    oauth_service.revoke(revoke_params, { method: :post }).call
  end

  def to_header
    { "Authorization" => "#{token_type.capitalize} #{access_token}"}
  end

  def to_cookie
    { value: Base64.encode64(to_h.to_json).strip, expires: expires }
  end

  def execute(method, *args, &block)
    block.call false, send(method, *args)
  rescue Services::Errors::HttpError => error
    block.call true, error
  end

  def self.from_cookie(cookie)
    new JSON.parse(Base64.decode64(cookie))
  end

  private

  def refresh_params
    {
      grant_type: 'refresh_token',
      client_id: User::CLIENT_ID,
      client_secret: User::CLIENT_SECRET,
      refresh_token: refresh_token
    }
  end

  def revoke_params
    {
      token: access_token,
      token_type_hint: 'access_token'
    }
  end

  def oauth_service
    @oauth ||= Services::Users.new(:oauth)
  end
end
