module VoteHelper
  def vote_class_for(id)
    if @user && (vote = @votes.find(id))
      vote.attitude > 0 ? 'upvoted' : 'downvoted'
    else
      ''
    end
  end
end
