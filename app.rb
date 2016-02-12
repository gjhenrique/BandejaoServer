require 'sinatra'
require 'sinatra/activerecord'

Dir.glob('./models/*.rb') { |file| require file }

get '/' do
  'Hello World'
end
