require 'rubygems'
require 'bundler'
Bundler.require

require 'application'

set :run, false
set :environment, :production
set :logging, true

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

run SemanticTweet
