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
  
  specify 'should get semantictweet page 10 times' do
    t = Time.now
    10.times do
      get '/semantictweet/friends'
      last_response.should be_ok
    end
    puts "#{Time.now - t} seconds taken"
  end
end
