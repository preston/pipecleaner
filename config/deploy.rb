# RVM Stuff...

require 'rvm/capistrano'
require 'bundler/capistrano'

set :rails_env,             'production'
set :rvm_type,              :system
set :rvm_ruby_string,       "ruby-2.0.0"
set :rvm_path,              "/usr/local/rvm"


set :application, "pipecleaner"
set :scm, :git
set :repository, "git@github.com:tgen/#{application}.git"
set :deploy_to, "/var/www/#{application}"


# Local Applicance
#role :web, "pipecleaner.local"                          # Your HTTP server, Apache/etc
#role :app, "pipecleaner.local"                          # This may be the same as your `Web` server
#role :db,  "pipecleaner.local", :primary => true # This is where Rails migrations will run


# TGen Cloud
role :web, "pipecleaner.tgen.org"                          # Your HTTP server, Apache/etc
role :app, "pipecleaner.tgen.org"                          # This may be the same as your `Web` server
role :db,  "pipecleaner.tgen.org", :primary => true # This is where Rails migrations will run


set :use_sudo,    false
# set :deploy_via, 'remote_cache'
set :deploy_via, 'copy'
set :user,      "apache"

after "deploy:migrate", 'deploy:cleanup'
# before "deploy:assets:precompile", "config:update"

set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :config do
 
  desc "Add server-only shared directories."
  task :setup, :roles => [:app] do
    run "mkdir -p #{shared_path}/config"
  end
  after "deploy:setup", "config:setup"
  
  desc "Update server-only config files to new deployment directory."
  task :update, :roles => [:app] do
    run "cp -Rfv #{shared_path}/config #{release_path}"
  end
  after "deploy:update_code", "config:update"

end

# delayed_job stuff
require "delayed/recipes"
set :rails_env, "production" #added for delayed job 
set :delayed_job_args, "-n 2"
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
