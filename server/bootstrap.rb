# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'roar/decorator'
require 'roar/json'
require 'i18n'
require 'rack/cors'
require 'dotenv'

require './app.rb'

Dir.glob('./models/*.rb') { |file| require file }
Dir.glob('./lib/*.rb') { |file| require file }
Dir.glob('./jobs/*.rb') { |file| require file }
Dir.glob('./controllers/*.rb') { |file| require file }
Dir.glob('./representers/*.rb') { |file| require file }

require './parsers/parsers'
