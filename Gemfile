source 'http://rubygems.org'

gem 'rails', '~> 3.0.0'

gem 'yayimdbs', :require => 'yay_imdbs'
gem 'toname', :require => 'to_name'

gem 'imagesize', :require => 'image_size'

gem 'will_paginate', '~> 3.0.pre2'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
#gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

group :development do
	gem "rspec-rails", "~> 2.0.0"
  gem "mongrel", "~> 1.2.0.pre2"	
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :test do
	gem "rspec-rails", "~> 2.0.0"

  gem "rcov"

  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'  
end

group :production do
	gem "mysql2"
end

# Bundle gems for certain environments:
# gem 'rspec', :group => :test
# group :test do
#   gem 'webrat'
# end
