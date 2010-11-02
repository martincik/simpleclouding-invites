require 'bundler'
Bundler.setup
require 'sinatra'

root_dir = Pathname(__FILE__).dirname

set :root, root_dir
set :views, File.join(root_dir, 'views')
set :run, false
set :environment, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)
set :app_file, File.join(root_dir, 'simpleclouding.rb')

log = File.new("log/sinatra.log", "w")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'simpleclouding'
run Sinatra::Application
