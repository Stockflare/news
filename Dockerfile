FROM stockflare/base

RUN RAILS_ENV=production bundle exec rake assets:precompile
