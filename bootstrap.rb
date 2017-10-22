# We could use Bundler.require, but I guess that explicit requires fits better our application
# http://myronmars.to/n/dev-blog/2012/12/5-reasons-to-avoid-bundler-require

require 'sinatra'
require 'sinatra/respond_with'
require 'sinatra/activerecord'
require 'sinatra/i18n'

require 'dotenv'

Dir.glob('./models/*.rb') { |file| require file }
Dir.glob('./jobs/*.rb') { |file| require file }
Dir.glob('./controllers/*.rb') { |file| require file }

require './parsers/parsers'

require './app.rb'
