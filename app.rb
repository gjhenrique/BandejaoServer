# We could use Bundler.require, but I guess that explicit requires fits better our application
# http://myronmars.to/n/dev-blog/2012/12/5-reasons-to-avoid-bundler-require

require 'sinatra'
require 'sinatra/respond_with'
require 'sinatra/activerecord'
require 'sinatra/asset_pipeline'
require 'rails-assets-skeleton'

Dir.glob('./models/*.rb') { |file| require file }
Dir.glob('./jobs/*.rb') { |file| require file }
Dir.glob('./controllers/*.rb') { |file| require file }

configure do
  set :root, File.dirname(__FILE__)

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
