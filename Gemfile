source "https://rubygems.org"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sqlite3'
gem 'sinatra-activerecord'
gem 'rake'
gem 'whenever'
gem 'sinatra-asset-pipeline'
gem 'sinatra-i18n'
gem 'sinatra-flash'
gem 'nokogiri'
gem 'puma'
gem 'gcm'
gem 'dotenv'

group :assets do
  source 'https://rails-assets.org' do
    gem 'rails-assets-pure'
    gem 'rails-assets-css-hamburgers'
  end
  gem 'font-awesome-sass', '~> 4.6.2'

  gem 'sass'
  gem 'uglifier'
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
