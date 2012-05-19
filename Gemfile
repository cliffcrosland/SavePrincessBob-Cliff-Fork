source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Frontend Toolkit
gem "milwaukee",  '1.0.0', :git => "http://github.com/trcarden/milwaukee.git", :ref => "f06e4a0d326414eec26daca6d8003f9d6ec7bd23"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
	gem 'sqlite3'
end

#use sqlite3 for local development and fancy postGres for stupid production (consider using gem 'thin' later)
group :production do
	gem 'pg'
	gem 'thin'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
