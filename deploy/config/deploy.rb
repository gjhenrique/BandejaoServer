# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'easymeal_deploy'

set :repo_url, 'https://github.com/gjhenrique/BandejaoServer.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :nginx_use_ssl, true if fetch(:stage) == :production

set :default_env, {
  'RACK_ENV' => 'production'
}

set :deploy_to, '/home/deploy/easy_meal_deploy'

set :rails_env, :production

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'db-prod', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :puma_workers, 1
after 'puma:check', 'puma:nginx_config'
after 'deploy:migrate', 'deploy:seed'
