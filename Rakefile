require 'sinatra/activerecord/rake'
require 'sinatra/asset_pipeline/task'
require './app'

Sinatra::AssetPipeline::Task.define! Sinatra::Application

namespace :parsers do
  task :parse_universities do
    ParserJob.parse_all
  end

  task :parse_university, [:name] do |_, args|
    university = University.by_name args[:name]
    ParserJob.parse_university university
  end
end

namespace :gcm do
  task :send_message, [:name] do |_, args|
    ParserJob.send_gcm args[:name]
  end

  task :test_key do
    puts ENV['GCM_KEY']
  end
end
