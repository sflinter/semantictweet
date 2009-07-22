require "#{File.dirname(__FILE__)}/spec_helper"

describe "Tweeter integration" do
  it 'should create semantic tweet user' do
    tweeter = Twitter.new('semantictweet')
    tweeter.screen_name.should == 'semantictweet'
    tweeter.url.should == 'http://semantictweet.com'
  end
  
  it 'should create semantic tweet user with followers' do
    tweeter = Twitter.new('semantictweet', 'followers')
    tweeter.screen_name.should == 'semantictweet'
    tweeter.url.should == 'http://semantictweet.com'
  end
  
  it 'should have the right number of friends' do
    tweeter = Twitter.new('semantictweet')
    tweeter.friends_count.should == tweeter.foafs.size
  end
  
  it 'should have the right number for all' do
    tweeter = Twitter.new('semantictweet', 'all')
    tweeter.foafs.size.should == tweeter.friends_count + tweeter.followers_count
  end
  
  it 'should not have a geoname without a location' do
    tweeter = Twitter.new('hughglaser', 'friends')
    tweeter.location.should.be_nil
    tweeter.geoname.should.be_nil
  end
end
