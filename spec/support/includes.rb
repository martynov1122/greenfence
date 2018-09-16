require File.join(File.dirname(__FILE__), "features")
require File.join(File.dirname(__FILE__), "api_helper")

RSpec.configure do |config|
  config.include Features, type: :feature

  config.include ApiHelper, type: :request

  config.include FactoryGirl::Syntax::Methods
end
