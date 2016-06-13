source "https://rubygems.org"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sqlite3'
gem 'sinatra-activerecord'
gem 'rake'
gem 'whenever'
gem 'sinatra-asset-pipeline'
gem 'sass'
gem 'sinatra-i18n'
gem 'nokogiri'
gem 'pdftohtmlr'
gem 'puma'
gem 'gcm'
gem 'dotenv'

group :assets do
  source 'https://rails-assets.org' do
    gem 'rails-assets-pure'
    gem 'rails-assets-css-hamburgers'
  end
  gem 'font-awesome-sass', '~> 4.6.2'
end

group :development, :test do
  gem 'pry'
  gem 'pry-doc'
  gem 'byebug', platform: :mri
  gem 'pry-byebug', platform: :mri

  gem 'rspec'
  gem 'factory_girl'
  gem 'rack-test'
  gem 'database_cleaner'
  gem 'capybara'
end
