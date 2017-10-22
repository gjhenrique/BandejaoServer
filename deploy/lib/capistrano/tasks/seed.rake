namespace 'deploy' do
  task 'seed' do
    on roles(:app) do
      within "#{release_path}" do
        execute :rake, 'db:seed'
      end
    end
  end
end
