require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  it 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end

  it 'should show the semantictweet page' do
    get '/semantictweet'
    last_response.status.should == 302
  end

  it 'should show the semantictweet friends page' do
    get '/semantictweet/friends'
    last_response.should be_ok
    last_response.body.should include 'foaf:PersonalProfileDocument'
  end

  it 'should show the semantictweet friends page' do
    get '/semantictweet/followers'
    last_response.should be_ok
    last_response.body.should include 'foaf:PersonalProfileDocument'
  end

  it 'should show the tag page' do
    tags = "%23dev8d+%23bc"
    get "/tags/#{tags}"
    last_response.should be_ok
    last_response.body.should include "<skos:Concept rdf:about=\"#{APP_CONFIG[:semantictweet][:base_uri]}/tags/#{tags}\">"
    last_response.body.should include "<foaf:Document rdf:about=\"#{APP_CONFIG[:twitter][:search_uri]}/search?q=#{tags}\">"
  end
end
