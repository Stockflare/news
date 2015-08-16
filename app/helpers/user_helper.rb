module UserHelper
  def header_partial
    @user ? 'authenticated' : 'anonymous'
  end
end
