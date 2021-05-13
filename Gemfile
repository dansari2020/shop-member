source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.6"

gem "listen"
gem "puma", "~> 4.0"
gem "rails", "~> 5.2"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

gem "devise"
gem "omniauth-oauth2"
gem "rollbar"
gem "omniauth-rails_csrf_protection"

group :development do
  gem "dotenv-rails"
  gem 'rubocop-rails'
  gem "rubocop-rails_config"
end

group :development, :test do
  gem "pry-byebug"
  gem "sqlite3", "~> 1.4.1"
end

group :production do
  gem "pg", "~> 1.1"
end

gem "sentry-ruby"
gem "sentry-rails"
