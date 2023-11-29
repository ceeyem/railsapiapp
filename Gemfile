source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.2"

gem "rack-cors"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'faker'
  gem 'dotenv-rails'
end

gem "ruby-openai"

gem "daru"

gem "rails-controller-testing", "~> 1.0"

gem "matrix", "~> 0.4.2"

gem "dockerfile-rails", ">= 1.5", :group => :development

gem "pg", "~> 1.5"

gem "sentry-ruby", "~> 5.13"

gem "sentry-rails", "~> 5.13"

gem "jwt"

