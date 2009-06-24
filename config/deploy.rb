set :repo_user, "sflinter"
set :user, 'flintero'
set :domain, 'semantictweet.com'
set :host, "aether.site5.com"
set :application, "semantictweet"
set :repository,  "git://github.com/#{repo_user}/#{application}.git"
set :deploy_to, "/home/#{user}/#{application}"
#default_run_options[:pty] = true

# misc options
set :scm, 'git'
set :deploy_via, :remote_cache
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :group_writable, false

set :keep_releases, 10

role :app, host
role :web, host
role :db,  host, :primary => true

namespace :deploy do
  desc "Restart the web server"
  task :restart, :roles => :app do
    run "cd /home/#{user}/public_html ; rm #{domain} ; ln -s /home/#{user}/#{application}/current/public ./#{domain}"
    run "cd /home/#{user}/#{application}/current/tmp ; touch restart.txt"
  end
end
