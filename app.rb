configure do
  set :root, File.dirname(__FILE__)
  set :is_production, (ENV['RACK_ENV'] == 'production')

  set :locales, Dir[File.join(settings.root, 'config', 'locales', '*.yml')]
  register Sinatra::I18n

  Dotenv.load

  # sinatra-flash setup
  enable :sessions

  set :assets_js_compressor, :uglifier
  set :assets_css_compressor, :sass
  register Sinatra::AssetPipeline
  # Code based in https://github.com/rails-assets/rails-assets-sinatra
  if defined?(RailsAssets)
    RailsAssets.load_paths.each do |path|
      settings.sprockets.append_path(path)
    end
  else
    STDERR.puts 'RailsAssets is not defined\n' \
      'sprockets will not include libraries from rails-assets'
  end
end
