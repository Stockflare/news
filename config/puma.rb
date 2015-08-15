workers Integer(ENV['PUMA_WORKERS'] || 3)
threads Integer(ENV['MAX_THREADS'] || 1), Integer(ENV['MAX_THREADS'] || 16)

preload_app!

rackup DefaultRackup
port ENV['PORT'] || 2345
environment ENV['RAILS_ENV'] || 'development'
