require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'database_cleaner'
require 'capybara/rspec'
require 'webmock'
require 'vcr'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../bootstrap.rb', __FILE__

# Don't print anything within tests
App.logger.level = Logger::Severity::UNKNOWN if App.test?

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

Capybara.app = Sinatra::Application

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.include FactoryGirl::Syntax::Methods
  c.include Capybara::DSL

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    FactoryGirl.create(:period, :both)
    FactoryGirl.create(:period, :breakfast)
    FactoryGirl.create(:period, :lunch)
    FactoryGirl.create(:period, :dinner)
  end

  c.around(:each) do |test|
    DatabaseCleaner.cleaning do
      test.run
    end
  end
end
