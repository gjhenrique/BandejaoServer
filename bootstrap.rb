require 'sinatra'
require 'sinatra/activerecord'
require 'i18n'

require 'dotenv'

require './app.rb'

Dir.glob('./models/*.rb') { |file| require file }
Dir.glob('./lib/*.rb') { |file| require file }
Dir.glob('./jobs/*.rb') { |file| require file }
Dir.glob('./controllers/*.rb') { |file| require file }

require './parsers/parsers'
