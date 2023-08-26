source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0.7", ">= 7.0.7.2"
gem "pg", "~> 1.1"
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

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rubocop'
end

group :test do
end
