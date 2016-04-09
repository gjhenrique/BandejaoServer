set :environment_variable, "RACK_ENV"
set :output, {error: 'log/parser_error.log', standard: 'log/parser_success.log'}

every 1.hour do
  rake "parsers:parse_universities"
end
