Dir["vendor/gems/*/lib"].each { |path| $:.unshift path } 

require 'application'

set :run, false
set :environment, :production
set :logging, true

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application
