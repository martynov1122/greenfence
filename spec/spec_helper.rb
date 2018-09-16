if !(ENV['ATHENA_CONFIG'] || '').split(/\s+/).include?('nocoveralls')
  require 'simplecov'
  require 'simplecov-html'
  require 'coveralls'
  require 'rspec/active_model/mocks'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start 'rails'
end
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'database_cleaner'
require 'rspec/rails'
# require 'rspec/autorun'


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.default_formatter = 'doc'

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.include FactoryGirl::Syntax::Methods
  # config.include Capybara::DSL
  # config.include RSpec::Rails::ControllerExampleGroup


  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  #cleaning the database after tests so factories do not cause validation errors
  # config.before(:each) do
  #   DatabaseCleaner.strategy = :transaction
  #   DatabaseCleaner.clean_with(:truncation)
  #   DatabaseCleaner.start
  # end

  # Does not help
  #config.before(:each) do
    #DatabaseCleaner.start
  #end

  config.render_views


  config.before(:suite) do
    query = "MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r"
    result = Neo4j::Session.current.query(query).to_a
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    # Address.any_instance.stub(:update_lat_lng)
    allow_any_instance_of(Address).to receive(:update_lat_lng)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: ['feature', 'request']) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start

  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

JsonSpec.configure do
  exclude_keys "lastModified", "created", "created_at", "updated_at", "id", "accountId", "authentication_token"
end
