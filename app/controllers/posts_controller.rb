class PostsController < ApplicationController
  before_action :parse_date

  def recent
    @mode = 'recent'
    populate_view_with recent_posts
    render :index
  end

  def popular
    @mode = 'popular'
    populate_view_with popular_posts
    render :index
  end

  private

  def parse_date
    date = post_params[:date]
    @date = date ? Time.parse(date) : Time.now.utc
  end

  def populate_view_with(data)
    @posts = data.body
    @cursor = data.headers['X-Cursor']
  end

  def popular_posts(opts = post_params)
    Services::News::Posts.new(:popular).get(opts).response
  end

  def recent_posts(opts = post_params)
    Services::News::Posts.new(:recent).get(opts).response
  end

  def post_params
    params.permit(:cursor, :date)
  end
end
