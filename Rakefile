require 'sinatra/activerecord/rake'

require 'resque/tasks'
require 'resque/scheduler/tasks'
require 'resque-scheduler'

require 'erb'
require './app'

namespace :resque do

  task :setup_schedule do
    file = "#{settings.root}/config/resque_queues.yml"
    schedules = YAML.load(ERB.new(File.read(file)).result)

    if schedules
      Resque.schedule = schedules
    else
      STDERR.puts 'Something went wrong with the configuration files. Do you have any universities'
      exit 1 unless schedules
    end
  end

  task scheduler: :setup_schedule
end
