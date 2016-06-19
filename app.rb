# We could use Bundler.require, but I guess that explicit requires fits better our application
# http://myronmars.to/n/dev-blog/2012/12/5-reasons-to-avoid-bundler-require

require 'sinatra'
require 'sinatra/respond_with'
require 'sinatra/activerecord'
require 'sinatra/asset_pipeline'
require 'sinatra/i18n'
require 'sinatra/capture'

require 'rails-assets-pure'
require 'rails-assets-css-hamburgers'
require 'font-awesome-sass'

require 'dotenv'

Dir.glob('./models/*.rb') { |file| require file }
Dir.glob('./jobs/*.rb') { |file| require file }
Dir.glob('./controllers/*.rb') { |file| require file }

require './views/view_helper.rb'
require './parsers/parsers'

configure do
  set :root, File.dirname(__FILE__)

  set :locales, Dir[File.join(settings.root, 'config', 'locales', '*.yml')]
  register Sinatra::I18n

  Dotenv.load

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
