# frozen_string_literal: true

namespace 'deploy' do
  task 'seed' do
    on roles(:app) do
      within release_path.to_s do
        execute :rake, 'db:seed'
      end
    end
  end
end
