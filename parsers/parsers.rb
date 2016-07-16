require File.expand_path '../parser_helper.rb', __FILE__
require File.expand_path '../fetcher.rb', __FILE__
Dir[File.dirname(__FILE__) + '/*.rb'].each { |file| require file; }

# Auto include Fetcher and ParserHelper for every class of this module that implements the parse method
classes = Parser.constants.map { |p| Parser.const_get(p) }
parser_classes = classes.select { |clazz| clazz.method_defined? :parse }
parser_classes.each do |clazz|
  clazz.send(:include, Parser::Fetcher, Parser::ParserHelper)
end
