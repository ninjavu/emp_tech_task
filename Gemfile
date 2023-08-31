source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0.7", ">= 7.0.7.2"
gem "pg", "~> 1.1"
gem "dry-validation"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "sidekiq"
gem "sidekiq-cron"
gem "redis", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'jwt'
gem 'aasm'
gem 'rack-cors'

group :development, :test do
  gem 'rspec-rails'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rubocop'
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
end

gem 'factory_bot_rails'
