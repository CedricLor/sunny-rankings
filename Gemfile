source 'https://rubygems.org'

# For Heroku
ruby '2.2.2'
gem 'rails_12factor', group: :production
# gem 'pg',             group: :production
gem 'pg'
gem 'puma',           group: :production

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

# Bootstrap
gem 'bootstrap-sass', '~> 3.3.1'
gem 'font-awesome-sass', '~> 4.2.0'
gem 'simple_form'
gem 'country_select'

# Security AWS
gem 'figaro'

# Paperclip and AWS
gem 'aws-sdk', '< 2.0'
gem 'paperclip'

# Authentification
gem 'devise'

# Geocoding
gem 'geocoder', '~> 1.2.9'

# Faker
gem 'faker', '~> 1.4.3'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Internationalization
gem 'rails-i18n', '~> 4.0.0'
gem 'devise-i18n'
gem 'devise-i18n-views'

# minispecs
gem 'minispec', '~> 0.0.5'

# pundit
gem 'pundit'

# Active Admin
gem 'activeadmin', github: 'activeadmin'

# Email validator
gem 'email_validator'

# Nested form handler
gem 'cocoon', '~> 1.2.6'

# Forest (DVerbustel's gem)
gem 'forest_liana'

# React
gem 'react-rails'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  # gem 'sqlite3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # help to kill N+1 queries and unused eager loading
  # gem 'bullet', '~> 4.14.7'

  # A Ruby code quality reporter
  # gem "rubycritic", :require => false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end
