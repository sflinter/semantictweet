require 'sinatra'
require 'spec'
require 'spec/interop/test'
require 'rack/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, true

require 'application'

Spec::Runner.configure do |config|
  # reset database before each example is run
#   config.before(:each) { DataMapper.auto_migrate! }
end
