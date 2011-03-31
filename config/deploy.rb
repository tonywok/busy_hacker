#================================================
# CONFIG
#================================================

set :application, "busy_hacker"
set :scm, :git
set :scm_username, "tonywok"
set :repository,  "git@github.com:tonywok/busy_hacker.git"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
set :stage, :production
# change this to a deploy user, experiencing some permissions issues
set :user, "ec2-user"
set :use_sudo, false
set :runner, "deploy"
set :deploy_to, "/webapps/#{stage}/#{application}"
set :app_server, :passenger
set :domain, "184.72.244.236"

#================================================
# ROLES
#================================================

role :web, domain
role :app, domain
role :db, domain, :primary => true

#================================================
# ROLES
#================================================

namespace :deploy do
  task :start, :roles => :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :stop, :roles => :app do
    # Do Nothing
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
