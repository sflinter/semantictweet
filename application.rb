require 'rubygems'
require 'environment'
require 'sinatra'
require 'builder'
require 'haml'
require 'twitter'

BASE_URL = 'http://semantictweet.com'

mime :rdf, 'application/rdf+xml'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

get '/' do
  haml :index
end

get '/screen_name' do
  redirect "/#{params[:screen_name]}"
end

get '/:screen_name' do
  @twitter = Twitter.new(params[:screen_name])
  if @twitter.exists?
    content_type :rdf
    builder :foaf
  else
    raise not_found
  end
end

error do
  e = require.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Appliation error'
end

not_found do
  @screen_name = params[:screen_name]
  haml :'404'
end
