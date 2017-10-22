require 'sinatra/activerecord/rake'
require 'sinatra/asset_pipeline/task'
require './bootstrap'

Sinatra::AssetPipeline::Task.define! Sinatra::Application

namespace :parsers do
  task :parse_universities do
    ParserJob.parse_all
  end

  task :parse_university, [:name] do |_, args|
    university = University.by_name args[:name]
    raise "There is no university with the name #{args[:name]}" if university.nil?
    ParserJob.parse_university university
  end
end

namespace :gcm do
  task :send_message, [:name] do |_, args|
    university = University.by_name args[:name]
    logger = ParserLogger.new(university)
    ParserJob.send_gcm_request university.main_name.downcase, logger
  end

  task :test_key do
    puts ENV['GCM_KEY']
  end
end
