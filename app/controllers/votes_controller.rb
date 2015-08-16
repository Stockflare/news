class VotesController < ApplicationController
  def vote
    current_user.votes.vote_for(params)
    render nothing: true
  end

  private

  def vote_params
    params.permit(:id, :attitude, :created_at)
  end

  def vote_service
    @vote ||= Services::News::Vote.new(:votes)
  end
end
