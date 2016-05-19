require File.expand_path '../parser_helper.rb', __FILE__
require File.expand_path '../fetcher.rb', __FILE__
Dir[File.dirname(__FILE__) + '/*.rb'].each { |file| require file; }
