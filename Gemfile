source 'https://rubygems.org'

gem 'rails', '~>4.0.0'


gem 'actionpack-action_caching', '~>1.0.0'
gem 'actionpack-page_caching', '~>1.0.0'
gem 'actionpack-xml_parser', '~>1.0.0'
gem 'actionview-encoded_mail_to', '~>1.0.4'
gem 'activerecord-session_store', '~>0.0.1'
gem 'activeresource', '~>4.0.0'
gem 'protected_attributes', '~>1.0.1'
gem 'rails-observers', '~>0.1.1'
gem 'rails-perftest', '~>0.0.2'
gem 'robocall'
gem 'activeadmin', github: 'activeadmin'
gem 'authority'
gem 'carmen'
gem 'rmagick', :require => 'RMagick'
gem 'devise_security_extension' , '0.7.2'
gem 'carrierwave'
gem 'carrierwave-crop'
gem 'delayed_job_active_record'
gem 'devise', '~> 3.4'
gem 'devise_invitable', '~> 1.3.4'
gem 'figaro'
gem 'faker'
# gem 'flowerbox'
# https://github.com/carrierwaveuploader/carrierwave/issues/679
gem 'fog'
gem 'foreman'
gem 'geokit'
gem 'geokit-rails', git: 'https://github.com/geokit/geokit-rails'
gem 'haml'
# issue with active admin requiring jquery-ui but newest versions of jquery-rails not including that file
# chose this option over updating activeadmin because of the 0.6.0 issue above
# http://stackoverflow.com/questions/16844411/rails-active-admin-deployment-couldnt-find-file-jquery-ui
gem 'jquery-rails', '2.3.0'
gem 'kaminari'
gem 'newrelic_rpm'
gem 'oj'
# gem 'paper_trail', '~> 2.7.2'
gem 'paper_trail'
gem 'pg'
# gem 'pose' , '~> 3.0'
gem 'pose'
gem 'rabl'
gem 'rails_secret_token_env'
gem 'ransack'
gem 'rolify'
gem 'rqrcode_png'
gem 'ruby-progressbar'
gem 'sections_rails'
gem 'enumerize'
gem 'state_machine'
# gem 'strong_parameters'
gem 'swagger-docs'
gem 'unicorn-rails'
gem 'useragent'
gem 'stripe'
## Gem required for calculating recurring dates
gem 'recurrence', :require => 'recurrence/namespace'
gem 'sunspot_rails'
gem 'pusher'
## Added for seed data generation
gem 'humanize'
# graph db
gem 'neo4j-core', '~> 4.0.7'
gem 'neography', '~>1.7.2'
gem 'neo4j', '~> 4.1.5'

# Gems used only for assets and not required
# in production environments by default.

# please setup this gem https://github.com/ai/autoprefixer-rails
gem 'autoprefixer-rails', '~> 5.2.0'


gem 'sass-rails',   '~> 5.0.3'
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby
gem 'uglifier', '>= 1.3.0'
gem 'acts_as_follower'
gem 'aws-sdk', '~> 2'
gem 'firebase'

gem 'quiet_assets', :group => :development
gem 'apipie-rails'
gem 'progress_bar'
# For editing json fields in Active Admin
gem 'activeadmin_hstore_editor'


gem 'omnicontacts'
# gem 'omnicontacts', :git => 'https://github.com/max1122/ibms-omnicontacts.git'

gem 'unread', :git => 'https://github.com/max1122/max-unread.git'

group :test, :development do
  gem 'rspec-activemodel-mocks'
  gem 'codeclimate-test-reporter'
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'selenium-webdriver', '~> 2.38.0'
  gem 'timecop'
  gem 'ruby-graphviz'
  gem 'simplecov'
  gem 'simplecov-html'
  gem 'shoulda'
  gem 'sunspot_solr'
  gem 'factory_girl_rails'    # Needed for database seeds.
end

group :development do
  gem 'spring', github: 'jonleighton/spring'
  gem 'listen'
  gem 'pry'
  gem 'better_errors'
  gem 'bullet'
  gem 'rails_best_practices'
  gem "letter_opener"

end
