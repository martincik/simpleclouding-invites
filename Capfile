load 'deploy' if respond_to?(:namespace) # cap2 differentiator

require 'bundler/capistrano'
require 'erb'

role :web, "simpleclouding.com"
role :app, "simpleclouding.com"
role :db,  "simpleclouding.com", :primary => true

set :application, "simpleclouding"
set :deploy_to, "/mnt/app/#{application}"
set :deploy_via, :export

set :repository, "git@github.com:martincik/simpleclouding-invites.git" 
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

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  end
end
after "deploy:symlink", "deploy:update_crontab"

task :copy_database_yml do
  run "cp #{shared_path}/config/database.yml #{release_path}/config"
end
after "deploy:update_code", :copy_database_yml

task :copy_shopify_yml do
  run "cp #{shared_path}/config/shopify.yml #{release_path}/config"
end
after "deploy:update_code", :copy_shopify_yml

