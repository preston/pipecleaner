source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.13'
gem 'thin'


# Twitter bootstrap layout.
gem "therubyracer"
gem "less-rails"
gem 'twitter-bootstrap-rails'

# Tagging
gem 'acts-as-taggable-on'

# Templating
gem 'slim-rails'

# Better paths.
gem 'friendly_id', '~> 4.0.9' # v5 is only for Rails v4

# Stages are ordered.
gem 'ranked-model'

# Accounts and administration.
gem 'devise'
gem 'cancan'

gem 'rails_admin'

# Background tasks.
gem 'delayed_job_active_record'
gem 'daemons'

# link_to_add_association
gem 'cocoon'

# Better controllers
gem 'inherited_resources'

# Service trigger processing
gem 'httparty'

gem 'will_paginate' # Pagination
gem 'figaro'		# Environment configuration


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :production do
	gem 'pg'	# Heroku
	gem 'mysql'	# For-realies production.
	gem 'thin'
end

group :development, :test do
	gem 'railroady'		# Diagraming
	gem 'sqlite3'
	gem 'capistrano'	# Deploy with Capistrano
	gem 'rvm-capistrano'
	gem 'factory_girl'
	gem 'factory_girl_rails'
	gem 'capybara-webkit'

	gem 'rspec-rails'
	gem 'shoulda-matchers'

	# Better debugging
	gem 'binding_of_caller'
	gem 'better_errors'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

