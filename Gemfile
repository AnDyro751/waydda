source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

#ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'split', require: 'split/dashboard'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'mongoid'
gem 'rolify'
# gem 'mongoid-slug'
gem 'bson_ext'
gem 'aasm'
gem 'phonelib'
gem 'email_address'
gem 'mongoid-geospatial'
gem 'rack-cors'
gem 'rqrcode'
gem 'twilio-ruby'
gem 'devise'
gem 'simple_form'
gem "aws-sdk-s3", "~> 1.14"
# gem 'react-rails'
# gem 'react_on_rails', '11.2.1'
gem "react_on_rails", "12.0.0" # Update to the current version
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'city-state'
gem "mapbox-sdk"
gem 'stripe'
gem 'stripe_event'
gem "view_component"
gem 'will_paginate', '~> 3.1.0'
gem "algoliasearch-rails"
gem 'smtpapi'
gem 'cancancan'
gem 'dropzonejs-rails'
gem "cocoon"
gem 'meta-tags'
gem "breadcrumbs_on_rails"
gem 'active_link_to'
gem "sentry-raven"
gem 'rubocop', require: false
gem 'geokit'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver

  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'database_cleaner'
  gem 'database_cleaner-mongoid'
  gem 'faker'
  gem 'mongoid-rspec'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mini_racer', platforms: :ruby
