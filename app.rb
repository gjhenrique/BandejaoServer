require 'sinatra'
require 'sinatra/activerecord'

Dir.glob('./models/*.rb') { |file| require file }
Dir.glob('./jobs/*.rb') { |file| require file }

set :root, File.dirname(__FILE__)

get '/' do
  'Hello World'
end
