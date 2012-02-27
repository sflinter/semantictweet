require 'rubygems'
require 'sinatra'
require 'rspec/core'
# require 'rspec/interop/test'
require 'rack/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, true

require 'application'

RSpec.configure do |config|

end
