set :runner, "john"
set :application, "frids-backend"
set :repository,  "http://boostrot.net/svn/frids-backend/trunk/frids-backend-webapp"
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
default_run_options[:pty] = true

role :web, "john@slice.boostrot.net"
role :app, "john@slice.boostrot.net"
role :db, "john@slice.boostrot.net", :primary => false

namespace :passenger do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :delayed_job do
  desc "Stop Delayed Job runner"
  task :stop, :roles => :app do
    run "#{current_path}/script/delayed_job stop"
  end
  desc "Start Delayed Job runner"
  task :start, :roles => :app do
    run "#{current_path}/script/delayed_job start -- production"
  end
end

namespace :deploy do
  %w(start restart).each { |name| task name, :roles => :app do passenger.restart end }
end

before "deploy", "delayed_job:stop"
after "deploy", "deploy:cleanup", "delayed_job:start"
