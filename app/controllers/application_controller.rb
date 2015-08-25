class ApplicationController < ActionController::Base
  LOGIN_COOKIE = :token

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate!

  before_action :fetch_votes, if: :logged_in?

  before_action :fetch_score, if: :logged_in?

  def authenticate!
    @user ||= current_user if logged_in?
  end

  def logged_in?
    token.is_a? Token
  end

  def current_user
    @current_user ||= User.get(token)
  end

  def token
    cookie = cookies[LOGIN_COOKIE]
    Token.from_cookie(cookies[LOGIN_COOKIE]) if cookie
  end

  def set_token(token)
    cookies[LOGIN_COOKIE] = token.to_cookie
  end

  def unset_token
    cookies[LOGIN_COOKIE] = { value: '', expires: 1.minute.ago }
  end

  private

  def fetch_score
    @score ||= current_user.votes.fetch!.score
  end

  def fetch_votes
    @votes ||= current_user.votes.fetch!
  end
end
