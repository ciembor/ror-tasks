require 'bundler/setup'
require 'rspec'
require 'rspec/expectations'
require 'rr'

RSpec.configure do |config|
  config.mock_with :rr
end
