require 'sinatra/activerecord/rake'
require 'sinatra/asset_pipeline/task'
require './app'

Sinatra::AssetPipeline::Task.define! Sinatra::Application

namespace :parsers do
  task :parse_universities do
    ParserJob.parse_all
  end
end
