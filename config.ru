require 'rubygems'

require './bootstrap'

use Rack::Cors do
  allow do
    resource '*', headers: :any, methods: %i[get options]
    origins '*'
  end
end

run Sinatra::Application
