require 'rubygems'
require 'rspec'
require 'rspec/collection_matchers'
require 'heroku_auto_scale'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.mock_framework = :rspec
end
