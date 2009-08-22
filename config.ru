require 'rubygems'
require 'sinatra.rb'

root_dir = Pathname(__FILE__).dirname

set :root, root_dir
set :views, File.join(root_dir, 'views')
set :run, false
set :environment, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)
set :app_file, File.join(root_dir, 'simpleclouding.rb')

require 'simpleclouding'
run Sinatra.application
