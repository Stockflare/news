class News < Hash

  class Collection
    include Virtus.value_object(coerce: true)

    values do
      attribute :cursor, String

      attribute :posts, Array, default: []
    end

    def initialize(response)
      super cursor: response.headers['X-Cursor'], posts: response.body
    end
  end

  def initialize(mode, date, opts = {})
    self[date] = Collection.new response(mode, date, opts)
  end

  private

  def response(mode, date, opts = {})
    Services::News::Posts.send(mode, opts.merge(date: date)).response
  end
end
