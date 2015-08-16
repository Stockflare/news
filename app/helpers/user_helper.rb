module UserHelper
  def header_partial
    @user ? 'authenticated' : 'anonymous'
  end

  def logged_in?
    @user != nil
  end
end
