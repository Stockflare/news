class User
  CLIENT_ID = ENV['CLIENT_ID']

  CLIENT_SECRET = ENV['CLIENT_SECRET']

  include Virtus.value_object(coerce: true)

  values do
    attribute :id, String

    attribute :username, String

    attribute :password, String

    attribute :otp, Integer, default: 0
  end

  def register!
    user_service.user(register_params, { method: :post }).call
  end

  def login!
    params = login_params
    params.merge!(otp: otp) if otp > 0
    oauth_service.token(params, { method: :post }).call
  end

  def execute(method, *args, &block)
    block.call false, send(method, *args)
  rescue Services::Errors::HttpError => error
    block.call true, error
  end

  def votes(opts = {})
    raise 'expected id not to be nil. error calling #votes' unless id
    @votes ||= Votes.new(user: self, opts: opts)
  end

  def self.get(token)
    response = Services::Users.user({}, { headers: token.to_header }).call.body.response
    new(username: response.email, id: response.guid)
  end

  private

  def register_params
    {
      email: username,
      password: password
    }
  end

  def login_params
    login = {
      grant_type: 'password',
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      username: username,
      password: password
    }
  end

  def oauth_service
    @oauth ||= Services::Users.new(:oauth)
  end

  def user_service
    @user ||= Services::Users
  end
end
