source 'https://rubygems.org'
ruby "2.2.1"

gem 'rails', '~> 3.2.13'
gem "rake", "~> 10.1.0"
gem 'pg', "0.18.2"
gem 'redis', "3.3.3"

gem 'haml', '~> 5.0'

gem 'test-unit', '~> 3.1', '>= 3.1.7'

gem "figaro", ">= 0.6.3"
gem 'newrelic_rpm', '3.7.1.182'
gem 'sendgrid', '1.2.0'

gem 'jquery-rails', "3.0.1"
gem 'bootstrap-sass', '3.1.1.0'
gem 'ember-rails', "0.14.1"
gem 'ember-source', '1.0.0.rc5' # or the version you need
gem 'handlebars-source', '1.0.0.rc4' # or the version you need
gem 'momentjs-rails'
gem 'async-rails'

gem "devise", "3.2.2"
gem "cancancan", "~> 1.15"
gem "simple_form", "2.1.1"

gem 'paperclip', '3.5.2'
gem 'aws-sdk', '1.32.0'
gem 'colorize'
gem 'exif', '~> 2'

gem 'thin', group: :production

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'faker'
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 0.7.2"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]

  gem 'mailcatcher'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', '~> 2.8.0', require: false
end
