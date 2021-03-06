require "#{File.dirname(__FILE__)}/spec_helper"

describe "Tweeter integration" do
  it 'should create semantic tweet user' do
    tweeter = Tweeter.new('semantictweet')
    tweeter.screen_name.should eq('semantictweet')
    tweeter.url.should eq('http://semantictweet.com')
  end
  
  it 'should create semantic tweet user with followers' do
    tweeter = Tweeter.new('semantictweet', 'followers')
    tweeter.screen_name.should eq('semantictweet')
    tweeter.url.should eq('http://semantictweet.com')
  end
  
  it 'should have the right number of friends' do
    tweeter = Tweeter.new('semantictweet')
    tweeter.friends_count.should eq(tweeter.foafs.size)
  end
  
  it 'should not have a geoname without a location' do
    tweeter = Tweeter.new('hughglaser', 'friends')
    tweeter.location.should eq('')
    tweeter.geoname.should be_nil
  end
end
