class UserApi

  cattr_accessor :endpoint
  self.endpoint = (ENV['CLIENT_ENDPOINT'] || "").gsub(/\/\Z/, '')

  cattr_accessor :client_id
  self.client_id = ENV['CLIENT_ID']

  cattr_accessor :client_secret
  self.client_secret = ENV['CLIENT_SECRET']

  extend ActiveSupport::Autoload

  autoload :Errors

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def self.login(params = {})
    with_rescue do
      connection.post login_url do |req|
        req.body = inject_login_params(params)
      end
    end
  end

  def self.register(opts = {})
    with_rescue do
      connection.post user_url do |req|
        req.body = opts
      end
    end
  end

  def authorization_header
    [user.token_type.capitalize.to_sym, user.access_token]
  end

  def me
    with_rescue do
      authenticated_connection.get user_url
    end
  end

  def refresh
    with_rescue do
      connection.post refresh_url do |req|
        req.body = refresh_params
      end
    end
  end

  def logout
    with_rescue do
      connection.post revoke_url do |req|
        req.body = revoke_params
      end
    end
  end

  private

  def refresh_params
    {
      grant_type: 'refresh_token',
      client_id: Api.client_id,
      client_secret: Api.client_secret,
      refresh_token: user.refresh_token
    }
  end

  def revoke_params
    {
      token: user.access_token,
      token_type_hint: 'acces_token'
    }
  end

  def refresh_url
    "/api/2/oauth/token"
  end

  def revoke_url
    "/api/2/oauth/revoke"
  end

  def with_rescue(&block)
    self.class.with_rescue &block
  end

  def connection
    self.class.connection
  end

  def authenticated_connection
    conn = Faraday.new(url: Api.endpoint)
    conn.authorization *authorization_header
    conn
  end

  def self.with_rescue
    begin
      response = yield
    rescue
      raise Errors::ServerError
    else
      if response.status == 200
        parsed = JSON.parse(response.body, symbolize_names: true)
        if parsed.key?(:response)
          JSON.parse(parsed[:response].to_json, symbolize_names: true)
        else
          parsed
        end
      else
        Errors.determine_from response
      end
    end
  end

  def self.inject_login_params(opts = {})
    {
      grant_type: 'password',
      client_id: Api.client_id,
      client_secret: Api.client_secret
    }.merge(opts)
  end

  def self.connection(&block)
    Faraday.new(url: Api.endpoint)
  end

  def user_url
    self.class.user_url
  end

  def self.user_url
    "/api/2/user"
  end

  def self.login_url
    "/api/2/oauth/token"
  end

end
