require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.include FactoryGirl::Syntax::Methods

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  c.around(:each) do |test|
    DatabaseCleaner.cleaning do
      test.run
    end
  end
end
