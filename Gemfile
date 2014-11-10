source 'https://rubygems.org'
ruby '2.1.4'

gem 'rails', '4.1.7'


# Twitter bootstrap layout.
gem "therubyracer"
gem "less-rails"
gem 'twitter-bootstrap-rails'

# Tagging
gem 'acts-as-taggable-on'

# Templating
gem 'slim-rails'

# Better paths.
gem 'friendly_id'

# Stages are ordered.
gem 'ranked-model'

# Accounts and administration.
gem 'devise'
gem 'cancancan'

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
  gem 'sass-rails',   '~> 4.0.3'
  # gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.3.0'
end

gem 'jquery-rails'

group :production do
	gem 'pg'
end

group :development, :test do
	gem 'railroady'		# Diagraming
	gem 'sqlite3'
	gem 'factory_girl'
	gem 'factory_girl_rails'
	gem 'capybara-webkit'

	gem 'rspec-rails'
	gem 'shoulda-matchers'

	gem 'capistrano'
	gem 'capistrano-rvm'
	gem 'capistrano-bundler'
	gem 'capistrano-rails'

	gem 'binding_of_caller'
	gem 'better_errors'
end
