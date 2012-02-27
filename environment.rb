# ENV['GEM_PATH'] = '/home/flintero/gems:/usr/lib/ruby/gems/1.8'
ENV['RACK_ENV'] ||= 'production'

require 'rubygems'
require 'haml'
require 'ostruct'
require 'yaml'

require 'sinatra' unless defined?(Sinatra)

configure do
  set :sessions, true

  SiteConfig = OpenStruct.new(
                 :title => 'SemanticTweet',
                 :author => 'Steve Flinter',
                 :url_base => 'http://semantictweet.com/'
               )

  # load local config
  raw_config = File.read("#{File.dirname(__FILE__)}/config/config.yml")
  APP_CONFIG = YAML.load(raw_config)[ENV['RACK_ENV']]

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
  
end
