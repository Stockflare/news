class User
  CLIENT_ID = ENV['CLIENT_ID']

  CLIENT_SECRET = ENV['CLIENT_SECRET']

  include Virtus.value_object(coerce: true)

  values do
    attribute :username, String

    attribute :password, String

    attribute :otp, Integer, default: 0
  end

  def get(token = nil)
    token = Token.new(login!.body) unless token
    puts({ headers: token.to_header }).inspect
    user_service.user({}, { headers: token.to_header }).call
  end

  def register!
    user_service.user(register_params, { method: :post }).call
  end

  def login!
    oauth_service.token(login_params, { method: :post }).call
  end

  def execute(method, *args, &block)
    block.call false, send(method, *args)
  rescue Services::Errors::HttpError => error
    block.call true, error
  end

  private

  def register_params
    {
      email: username,
      password: password
    }
  end

  def login_params
    {
      grant_type: 'password',
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      username: username,
      password: password,
      otp: otp
    }
  end

  def oauth_service
    @oauth ||= Services::Users.new(:oauth)
  end

  def user_service
    @user ||= Services::Users
  end
end
