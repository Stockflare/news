class UsersController < ApplicationController

  before_action :set_register_mode, only: [:register, :create]

  before_action :set_login_mode, only: [:login, :authenticate]

  def register

  end

  def create

  end

  def login

  end

  def authenticate

  end

  private

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
