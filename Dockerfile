FROM stockflare/base

RUN bundle exec rake assets:precompile
