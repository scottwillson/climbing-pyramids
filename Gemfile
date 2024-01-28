# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise"
gem "importmap-rails"
gem "jbuilder"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3"
gem "redis", ">= 4.0.1"
gem "sassc-rails"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rubocop"
  gem "rubocop-capybara"
  gem "rubocop-performance"
  gem "rubocop-rails"
end

group :development do
  gem "brakeman"
  gem "foreman"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "webmock"
end
