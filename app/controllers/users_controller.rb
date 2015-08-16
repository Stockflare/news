class UsersController < ApplicationController

  before_action :set_register_mode, only: [:register, :create]

  before_action :set_login_mode, only: [:login, :authenticate]

  before_action :redirect_if_authenticated, only: [:login, :register]

  def register
    redirect_to :root if logged_in?
  end

  def login
    redirect_to :root if logged_in?
  end

  def create
    User.new(user_params).execute(:register!) do |error, response|
      if error
        body = JSON.parse(response.body)
        @errors = registration_errors body['messages']
        render :register
      else
        authenticate
      end
    end
  end

  def logout
    if logged_in?
      token.logout!
      unset_token
    end
    redirect_to :root
  end

  def authenticate
    User.new(user_params).execute(:login!) do |error, response|
      if error
        body = JSON.parse(response.body)
        puts body.inspect
        @username = user_params[:username]
        if body["error"] == "mfa_enforced"
          @errors = ['Invalid MFA Code'] if user_params[:otp]
          @password = user_params[:password]
          render :mfa
        else
          @errors = ['Invalid username or password']
          render :login
        end
      else
        set_token Token.new response.body
        redirect_to :root
      end
    end
  end

  private

  def registration_errors(messages)
    errors = []
    messages.each do |key, value|
      case key
      when 'encrypted_email'
        value.each { |val| errors << "Email #{val}" }
      else
        value.each { |val| errors << "#{key.capitalize} #{val}" }
      end
    end
    errors
  end

  def redirect_if_authenticated
    redirect_to :root if logged_in?
  end

  def set_register_mode
    @mode = 'register'
  end

  def set_login_mode
    @mode = 'login'
  end

  def user_params
    params.permit(:username, :password, :otp)
  end

end
