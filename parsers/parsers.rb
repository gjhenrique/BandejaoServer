# frozen_string_literal: true

require File.expand_path 'parser_helper.rb', __dir__
require File.expand_path 'fetcher.rb', __dir__
Dir[File.dirname(__FILE__) + '/*.rb'].each { |file| require file }
