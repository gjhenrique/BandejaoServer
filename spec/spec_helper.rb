require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'database_cleaner'
require 'capybara/rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

Capybara.app = Sinatra::Application

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

RSpec.configure do |c|
  c.include RSpecMixin

  c.include FactoryGirl::Syntax::Methods
  c.include Capybara::DSL

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
