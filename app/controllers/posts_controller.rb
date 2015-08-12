class PostsController < ApplicationController

  def show
  end

  def index
    @posts = Services::News::Posts.new(:posts).get.response
  end
  
end