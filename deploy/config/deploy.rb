# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'easymeal_deploy'

set :repo_url, 'https://github.com/gjhenrique/BandejaoServer.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :nginx_use_ssl, true if fetch(:stage) == :production

# Default deploy_to directory is /var/www/my_app_name
set :default_env, {
  'RACK_ENV' => 'production'
}

set :deploy_to, '/home/deploy/easy_meal_deploy'

set :rails_env, :production
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'db-prod', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for keep_releases is 5
# set :keep_releases, 5
set :puma_workers, 1
after 'puma:check', 'puma:nginx_config'
after 'deploy:migrate', 'deploy:seed'
