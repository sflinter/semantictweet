require 'sinatra'
require 'rspec/core'
require 'rack/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, true

require 'application'

RSpec.configure do |config|

end
