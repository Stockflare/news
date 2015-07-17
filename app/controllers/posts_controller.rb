class PostsController < ApplicationController

  def show
  end

  def index
    puts Shotgun::Services::News::Posts.get.response.inspect
  end
  
end