require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  specify 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end

  specify 'should show the semantictweet page' do
    get '/semantictweet'
    last_response.status.should == 302
  end

  specify 'should show the semantictweet friends page' do
    get '/semantictweet/friends'
    last_response.should be_ok
    last_response.body.should include 'foaf:PersonalProfileDocument'
  end

  specify 'should show the semantictweet friends page' do
    get '/semantictweet/followers'
    last_response.should be_ok
    last_response.body.should include 'foaf:PersonalProfileDocument'
  end

  specify 'should show the tag page' do
    get '/tag/%23dev8d+%23bc'
    puts "#{APP_CONFIG[:semantictweet][:base_uri]}"
    puts last_response.body
    last_response.status.should == 200
    last_response.should be_ok
    puts last_response.body
    last_response.body.should include '<skos:Concept rdf:about="http://semantictweet.com/tag/%23dev8d+%23bc">'
    last_response.body.should include '<foaf:Document rdf:about="http://search.twitter.com/search?q=%23dev8d+#23bc">'
  end
end
