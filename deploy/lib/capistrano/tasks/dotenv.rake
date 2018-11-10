# frozen_string_literal: true

# Inspired in https://github.com/eduardodeoh/capistrano/blob/master/lib/capistrano/tasks/dotenv.rake
namespace :deploy do
  namespace :dotenv do
    task :setup do
      on roles :app do
        from = File.open 'lib/capistrano/files/.env'
        to = "#{shared_path}/.env"
        upload! from, to
      end
    end
    after 'deploy:started', 'deploy:dotenv:setup'

    task :symlink do
      on roles :app do
        execute :ln, '-nfs', "#{shared_path}/.env", "#{release_path}/.env"
      end
    end
    before 'deploy:updated', 'deploy:dotenv:symlink'
  end
end
