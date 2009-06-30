require 'rubygems'
require 'environment'
require 'sinatra'
require 'builder'
require 'haml'
require 'twitter'
require 'uri'

BASE_URL = 'http://semantictweet.com'

mime :rdf, 'application/rdf+xml'

helpers do
  def valid_uri?(uri = "")
    begin
      URI.parse(uri)
      true
    end
  rescue URI::InvalidURIError
    false
  end
end

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

get '/' do
  haml :index
end

get '/about' do
  haml :about
end

get '/contact' do
  haml :contact
end

get '/friends' do
  Twitter.new('semantictweet').friends
end

get '/followers' do
  Twitter.new('semantictweet').followers
end

get '/screen_name' do
  redirect "/#{params[:screen_name]}"
end

get '/:screen_name/:who' do
  @twitter = Twitter.new(params[:screen_name])
  if @twitter.exists?
    @foafs = @twitter.who(params[:who])
    content_type :rdf
    builder :foaf
  else
    raise not_found
  end
end

get '/:screen_name' do
  redirect "#{params[:screen_name]}/friends"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Oops, we messed up!'
end

not_found do
  @screen_name = params[:screen_name]
  haml :'404'
end
