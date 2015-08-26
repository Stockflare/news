class PostsController < ApplicationController
  before_action :parse_tags

  def recent
    populate_view_with recent_posts
  end

  def popular
    populate_view_with popular_posts
  end

  private

  def date(offset = 0)
    date_param = post_params[:date]
    @date = (date_param ? Time.parse(date_param) : Time.now.utc) + offset
  end

  def recent_posts
    Feed.new(:recent, date, post_params)
  end

  def popular_posts
    (0...3).to_a.collect do |i|
      Feed.new(:popular, date(-(24 * 60 * 60 * i)), post_params)
    end.reduce(&:merge)
  end

  def parse_tags
    tags = post_params[:tags]
    @tags = tags ? tags.split(/, ?/) : []
  end

  def populate_view_with(posts)
    @cursor = posts[@date].cursor
    @posts = posts
  end

  def post_params
    parsed = params.permit(:cursor, :date)
  end
end
