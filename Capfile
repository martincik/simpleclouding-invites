load 'deploy' if respond_to?(:namespace) # cap2 differentiator

require 'erb'

role :web, "simpleclouding.com"
role :app, "simpleclouding.com"
role :db,  "simpleclouding.com", :primary => true

set :application, "simpleclouding"
set :deploy_to, "/mnt/app/#{application}"
set :deploy_via, :export

set :repository, "git@github.com:lacomartincik/simpleclouding-invites.git" 
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

set :user, "www-data"
set :group, "www-data"
set :use_sudo, false
set :keep_releases, 2

default_run_options[:pty] = true

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "mkdir -p #{current_path}/app/tmp"
    run "touch #{current_path}/app/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end