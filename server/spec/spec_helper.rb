# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'factory_bot'
require 'database_cleaner'
require 'capybara/rspec'
require 'webmock'
require 'vcr'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../bootstrap.rb', __dir__

# Don't print anything within tests
App.logger.level = Logger::Severity::UNKNOWN if App.test?

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

Capybara.app = Sinatra::Application

FactoryBot.definition_file_paths = [File.expand_path('factories', __dir__)]
FactoryBot.find_definitions

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.include RSpecMixin

  c.include FactoryBot::Syntax::Methods
  c.include Capybara::DSL

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    FactoryBot.create(:period, :both)
    FactoryBot.create(:period, :breakfast)
    FactoryBot.create(:period, :lunch)
    FactoryBot.create(:period, :dinner)
  end

  c.around do |test|
    DatabaseCleaner.cleaning do
      test.run
    end
  end
end
