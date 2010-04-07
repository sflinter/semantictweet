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
    last_response.body.should include 'foaf:PersonalProfileDocument'
    last_response.status.should == 302
  end

  specify 'should show the semantictweet friends page' do
    get '/semantictweet/friends'
    last_response.should be_ok
    last_response.body.should include 'foaf:PersonalProfileDocument'
  end
end
