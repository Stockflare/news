module UserHelper
  def current_user
    nil
  end

  def header_partial
    current_user ? 'authenticated' : 'anonymous'
  end
end
