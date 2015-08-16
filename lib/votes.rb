class Votes < Array
  class Vote
    include Virtus.value_object(coerce: true)

    values do
      attribute :id, String

      attribute :attitude, Integer, default: 0
    end
  end

  include Virtus.value_object(coerce: true)

  values do
    attribute :user, User

    attribute :opts, Hash, default: {}
  end

  def find(id)
    each { |vote| return vote if vote.id == id }
    return nil
  end

  def vote_for(params)
    vote_service.update(params.merge({ origin_id: user.id, })).call
  end

  def cursor
    response.headers['X-Cursor']
  end

  def cursor?
    cursor != nil
  end

  def fetch!
    concat response.body.collect { |resp| Vote.new resp }
    self
  end

  def next_page
    if cursor?
      self.class.new(user: user, opts: opts.merge(cursor: cursor)).fetch!
    else
      []
    end
  end

  private

  def response
    @response ||= vote_service.get(opts.merge(origin_id: user.id)).response
  end

  def vote_service
    @vote ||= Services::News::Vote.new(:votes)
  end
end
