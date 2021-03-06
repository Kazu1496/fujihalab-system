source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'
gem 'rails', '~> 5.2.2'
gem 'puma', '~> 3.11'
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'sass-rails', '~> 5.0'
gem 'haml-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-attack', '~> 5.0.1'
gem 'dotenv-rails'
gem 'rack-attack', '~> 5.0.1'
gem 'carrierwave'
gem 'mini_magick'
gem 'cloudinary'
gem 'bcrypt'
gem 'slack-notifier'
gem 'whenever', require: false
gem "font-awesome-sass"
gem "jquery-rails"
gem 'simple_form'
gem 'will_paginate'
gem 'serviceworker-rails'
gem 'brakeman'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3', '~> 1.3.6'

  # pry用諸々
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'
  # rubymine用デバッガー
  gem 'ruby-debug-ide', '0.7.0.beta7'
  gem 'debase', '0.2.3.beta3'
end

group :development do
  # access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # spring speeds up development by keeping your application running in the background. read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest', '5.11.3'
  gem 'minitest-reporters', '1.1.14'
  gem 'guard', '2.13.0'
  gem 'guard-minitest', '2.4.4'
end

group :production, :staging do
  gem 'mysql2'
  gem 'unicorn', '5.4.1'
end
