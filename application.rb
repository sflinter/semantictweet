require 'environment'
require 'sinatra'
require 'builder'
require 'twitter_oauth'
require 'haml'
require 'tweeter'
require 'geonames'
require 'uri'

# Gems related to rate limiting
require 'rack/throttle'
require 'gdbm'

class SemanticTweet < Sinatra::Application

  # Throttle, with a max of 100 queries per hour
  use Rack::Throttle::Hourly, :max => 100, :cache => GDBM.new('tmp/throttle.db')

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
    mime_type :rdf, 'application/rdf+xml'
    set :views, "#{File.dirname(__FILE__)}/views"
  end

  before do
    next if request.path_info =~ /ping$/
    @client = TwitterOAuth::Client.new(
                :consumer_key => ENV['CONSUMER_KEY'] || APP_CONFIG[:twitter][:consumer_key],
                :consumer_secret => ENV['CONSUMER_SECRET'] || APP_CONFIG[:twitter][:consumer_secret],
                :token => APP_CONFIG[:twitter][:access_token],
                :secret => APP_CONFIG[:twitter][:access_token_secret]
                                       )
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

  get '/favicon.ico' do
  end

  # Note the formulation of a specific regexp is required here. The
  # preferred option of '/tag/:tags' doesn't match all URIs properly
  get %r{\A/tags/(.*)} do |tags|
    @tags = tags.split(' ')
    content_type :rdf
    builder :tags
  end

  get '/screen_name' do
    redirect "/#{params[:screen_name]}"
  end

  get '/:screen_name/:who' do
    @tweeter = Tweeter.new(@client, params[:screen_name], params[:who])
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
end
