source 'https://rubygems.org'

ruby "3.1.2"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.7'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1.4'
# Use Puma as the app server
gem "puma", ">= 6.3.1"
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 4.1.20'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
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

# See https://github.com/icalendar/icalendar
gem 'icalendar'

# See https://github.com/bokmann/fullcalendar-rails
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
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.1.3'
  gem 'better_errors'
  gem 'brakeman' # https://github.com/presidentbeef/brakeman
  gem 'bullet' # https://github.com/flyerhzm/bullet
  gem 'rails_best_practices' # Run: rails_best_practices . (https://github.com/flyerhzm/rails_best_practices)
  gem 'rack-mini-profiler' # https://github.com/MiniProfiler/rack-mini-profiler
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Added gems:

# See https://github.com/glebm/popper_js-rubygem
gem 'popper_js', '~> 1.16.1' # tooltips

# See https://github.com/twbs/bootstrap-rubygem
gem 'bootstrap', '~> 4.6.1'

# See https://github.com/Angelmmiguel/material_icons
gem 'material_icons'

# See https://github.com/bcrypt-ruby/bcrypt-ruby
gem 'bcrypt'

# See https://github.com/plataformatec/devise
gem 'devise'

# See https://github.com/laserlemon/figaro
gem 'figaro'

# See https://github.com/rails/jquery-rails
gem 'jquery-rails'

# See https://github.com/jquery-ui-rails/jquery-ui-rails
gem 'jquery-ui-rails'

# See https://github.com/kossnocorp/jquery.turbolinks
gem 'jquery-turbolinks'

# See https://github.com/haml/haml-rails
gem 'haml-rails', '~> 2.0'

# See https://devcenter.heroku.com/articles/getting-started-with-rails4#visit-your-application
group :staging, :production do
  gem 'rails_12factor'
end

# See https://github.com/airblade/paper_trail
gem 'paper_trail'

# # See https://github.com/thoughtbot/paperclip
# gem 'gem "paperclip", "~> 5.0.0"'

# See https://github.com/challonge-community/challonge-ruby-gem
gem 'challonge-api'

# See https://github.com/mislav/will_paginate
gem 'will_paginate'

# See https://github.com/iain/http_accept_language
gem 'http_accept_language'

# See https://nokogiri.org/
gem "nokogiri", ">= 1.13.9"

# See https://github.com/ambethia/recaptcha
gem 'recaptcha'

# See https://github.com/smartinez87/exception_notification
gem 'exception_notification'

# See https://github.com/svenfuchs/rails-i18n
gem 'rails-i18n', '~> 7.0.0'

# See https://github.com/tigrish/devise-i18n
gem 'devise-i18n'

# See https://github.com/fnando/i18n-js
gem 'i18n-js', '>= 3.9.2', '< 5.0.0' #blup: errors after updating (not worth it)

# See https://github.com/brendon/acts_as_list
gem 'acts_as_list'

# See https://github.com/kpumuk/meta-tags
gem 'meta-tags'

# See https://github.com/infinum/cookies_eu
gem 'cookies_eu'

# See https://github.com/thredded/thredded
gem 'thredded', '~> 1.0'
gem 'html-pipeline', '2.14.0' #blup: error when calling rails s with v2.14.1
gem "addressable", ">= 2.8.0" # https://github.com/Yoshi20/SSB-Tournament-Manager/security/dependabot/6

# See https://github.com/mbleigh/acts-as-taggable-on
gem 'acts-as-taggable-on'

# See https://github.com/argerim/select2-rails
gem "select2-rails"
