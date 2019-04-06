source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1.3'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 4.1.20'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.8'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'icalendar'
gem 'fullcalendar-rails'
gem 'momentjs-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.12'
  gem 'selenium-webdriver'
  gem 'pry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Added gems:

#https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '~> 3.4.0'

#
gem 'bcrypt'

# See https://github.com/plataformatec/devise
gem 'devise'

# See https://github.com/laserlemon/figaro
gem 'figaro'

# See https://github.com/rails/jquery-rails
gem 'jquery-rails'

# See https://github.com/kossnocorp/jquery.turbolinks
gem 'jquery-turbolinks'

# See http://haml.info
gem 'haml-rails'

# See https://devcenter.heroku.com/articles/getting-started-with-rails4#visit-your-application
gem 'rails_12factor', group: :production

# See https://github.com/airblade/paper_trail
gem 'paper_trail'

# # See https://github.com/thoughtbot/paperclip
# gem 'gem "paperclip", "~> 5.0.0"'

# See https://github.com/challonge-community/challonge-ruby-gem
gem 'challonge-api'

# See https://github.com/mislav/will_paginate
gem 'will_paginate', '~> 3.1.0'
