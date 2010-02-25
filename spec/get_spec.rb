require "#{File.dirname(__FILE__)}/spec_helper"

describe 'GET /semantictweet' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  specify 'should get the semantictweet page' do
    get '/semantictweet/friends'
    last_response.should be_ok
  end
end
