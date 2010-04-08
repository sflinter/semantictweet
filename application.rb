require 'environment'
require 'sinatra'
require 'builder'
require 'haml'
require 'tweeter'
require 'geonames'
require 'uri'

mime_type :rdf, 'application/rdf+xml'

helpers do
  def valid_uri?(uri = "")
    begin
      URI.parse(uri)
      true
    rescue URI::InvalidURIError
      false
    end
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

# Note the formulation of a specific regexp is required here. The
# preferred option of '/tag/:tags' doesn't match all URIs properly
get %r{\A/tag/(.*)} do |tags|
  resp = ""
  tags.split(' ').each do |tag|
    resp << "<p>/tag/#{tag}</p>"
  end
  resp
end

get '/screen_name' do
  redirect "/#{params[:screen_name]}"
end

get '/:screen_name/:who' do
  @tweeter = Tweeter.new(params[:screen_name], params[:who])
  if @tweeter.exists?
    content_type :rdf
    builder :foaf
  else
    raise not_found
  end
end

get '/:screen_name' do
  redirect "/#{params[:screen_name]}/friends"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  content_type :html
  'Oops, we messed up!'
end

not_found do
  @screen_name = params[:screen_name]
  haml :'404'
end
