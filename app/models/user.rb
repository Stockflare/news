class User < ActiveRecord::Base

  validates :access_token, presence: true

  validates :token_type, presence: true

  validates :expires_at, presence: true

  validates :expires_in, presence: true, numericality: { greater_than: 0 }

  def info
    @info ||= api.me
  end

  alias_method :information, :info

  def refresh?
    (expires_at - (expires_in / 2)).to_i < Time.now.to_i
  end

  def refresh!
    attributes = api.refresh
    attributes[:expires_at] = Time.now + attributes[:expires_in]
    update_attributes attributes
    true
  rescue UserApi::Errors::UserNotFound => e
    raise ActiveRecord::RecordNotFound.new
  rescue UserApi::Errors::ServerError
    raise ActiveRecord::ConnectionNotEstablished.new
  end

  def logout!
    api.logout
    self.delete
  rescue UserApi::Errors::ServerError
    raise ActiveRecord::ConnectionNotEstablished.new
  end

  def self.login!(username, password, otp = nil)
    attributes = UserApi.login({ username: username, password: password, otp: otp })
    attributes[:expires_at] = Time.now + attributes[:expires_in]
    create! attributes
  rescue UserApi::Errors::MfaEnforced => e
    user = self.new
    user.errors.add(:otp, "can't be blank")
    raise ActiveRecord::RecordInvalid.new user
  rescue UserApi::Errors::ServerError
    raise ActiveRecord::ConnectionNotEstablished.new
  rescue UserApi::Errors::UserNotFound => e
    raise ActiveRecord::RecordNotFound.new
  end

  def self.register!(username, password)
    UserApi.register({ email: username, password: password })
    self.login!(username, password)
  rescue UserApi::Errors::BadRequest => e
    user = self.new
    e.response["messages"].each do |key, errors|
      errors.each { |error| user.errors.add(key.to_sym, error) }
    end
    raise ActiveRecord::RecordInvalid.new user
  rescue UserApi::Errors::ServerError
    raise ActiveRecord::ConnectionNotEstablished.new
  end

  def self.authenticate(access_token)
    if user = self.find_by_access_token(access_token)
      user.refresh! if user.refresh?
      user
    else
      false
    end
  end

  private

  def api
    UserApi.new(self)
  end

end
