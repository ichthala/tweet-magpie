require 'twitter'
require 'factory_girl'
require 'webmock/rspec'
require 'rspec-mocks'
require_relative '../magpie'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end