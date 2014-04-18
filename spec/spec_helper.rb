require 'simplecov'
SimpleCov.start

require 'bundler/setup'

require 'rspec'
require 'mocha'
require 'bourne'

require 'rails' # for the engine

require File.expand_path('../../lib/swagger_yard', __FILE__)

# Dir["./spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :mocha

  config.order = 'random'
end
