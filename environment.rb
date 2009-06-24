ENV['GEM_PATH'] = '/home/flintero/gems:/usr/lib/ruby/gems/1.8'

require 'rubygems'
require 'haml'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'SemanticTweet',
                 :author => 'Steve Flinter',
                 :url_base => 'http://semantictweet.com/'
               )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
end
