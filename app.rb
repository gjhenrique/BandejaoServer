configure do
  set :root, File.dirname(__FILE__)
  set :is_production, (ENV['RACK_ENV'] == 'production')

  set :locales, Dir[File.join(settings.root, 'config', 'locales', '*.yml')]
  register Sinatra::I18n

  Dotenv.load
end
