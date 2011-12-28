default_run_options[:pty] = true

set :application, "Thread Prettier"
set :repository,  "git@github.com:29decibel/thread_prettier.git"
set :user,"ldb"
set :deploy_via, :remote_cache

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "29decibel.me"                  ,:primary => true        # Your HTTP server, Apache/etc
#role :app, "oesnow.com"                          # This may be the same as your `Web` server
#role :db,  "oesnow.com", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do

  desc "deploy the dev app"
  task :production do
    # you just told the cap where you what to put , and then the current,release and shared folder will created
    # for you
    set :deploy_to, "/home/ldb/tp"
    set :branch, "origin/master"
    set :env, "production"
    
    transaction do
      update_code
      #symlink
      install_gem
      migrate
      assets
      delayed_jobs
    end

    restart
  end

  task :update_code do
    run "cd #{deploy_to}/current; git fetch origin; git reset --hard #{branch}"
    run "cd #{deploy_to}/current && rm config/database.yml && ln -s #{deploy_to}/shared/database.yml config/database.yml"
  end

  desc "preco"
  task :assets do
    run "cd #{deploy_to}/current && bundle exec rake assets:precompile"
  end

  desc "update images"
  task :update_images do
    run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake uploader:recreate_versions"
  end

  desc "copy configs"
  task :install_gem do
    run "cd #{deploy_to}/current && bundle install --deployment"
  end

  desc "migrations"
  task :migrate do
    #run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake db:create"
    run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake db:auto:migrate"
    run "rm -rf #{deploy_to}/current/public/stylesheets/*.cache.css"
    run "rm -rf #{deploy_to}/current/public/stylesheets/compiled/*"
    run "rm -rf #{deploy_to}/current/public/javascripts/*.cache.js"
  end

  desc "restart delayed jobs"
  task :delayed_jobs do
    run "cd #{deploy_to}/current && RAILS_ENV=production script/delayed_job stop"
    run "cd #{deploy_to}/current && RAILS_ENV=production script/delayed_job -n 2 start"
  end

  desc "Restart unicorn"
  task :restart do
    run "#{try_sudo} kill -USR2 `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end
end
