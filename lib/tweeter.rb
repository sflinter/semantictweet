require 'httparty'
require 'uri'
require 'pp'
require 'geonames'

class Tweeter
  include Comparable
  include HTTParty
  base_uri APP_CONFIG[:twitter][:base_uri]
  basic_auth APP_CONFIG[:twitter][:basic_auth_username], APP_CONFIG[:twitter][:basic_auth_password]
  
  attr_reader :foafs, :geoname
  
  def initialize(tweeter, who = 'friends')
    @foafs = []
    
    case tweeter
    when String
      @given_screen_name = URI.escape(tweeter)
      @tweeter = self.show
      if self.exists?
        foafs = self.who(who)
        @foafs = foafs.map { |foaf| Tweeter.new(foaf) }
#         @geoname = GeoNames.new(@tweeter['location']) unless @tweeter['location'].blank?
      end
    when Hash
      @tweeter = tweeter
    end
    
    # This is somewhat of an ugly hack. The alternative is to put this
    # logic in method_missing()
    @tweeter['url'] = '' unless @tweeter['url']
  end
  
  def exists?
    @exists
  end
  
  def show
    puts "Calling: #{APP_CONFIG[:twitter][:base_uri]}/#{APP_CONFIG[:twitter][:api_version]}/users/show.json?screen_name=#{@given_screen_name}"
    resp = self.class.get("/#{APP_CONFIG[:twitter][:api_version]}/users/show.json?screen_name=#{@given_screen_name}")
    @exists = resp.code.between?(200,299)
    resp
  end
  
  def friends
    puts "Calling: #{APP_CONFIG[:twitter][:base_uri]}/#{APP_CONFIG[:twitter][:api_version]}/statuses/friends/#{@given_screen_name}.json"
    resp = self.class.get("/#{APP_CONFIG[:twitter][:api_version]}/statuses/friends/#{@given_screen_name}.json")
    resp
  end
  
  def followers
    puts "Calling: #{APP_CONFIG[:twitter][:base_uri]}/#{APP_CONFIG[:twitter][:api_version]}/statuses/followers/#{@given_screen_name}.json"
    self.class.get("/#{APP_CONFIG[:twitter][:api_version]}/statuses/followers/#{@given_screen_name}.json")
  end
  
  def all
    self.friends | self.followers
  end
  
  def who(who)
    case who
    when 'friends': self.friends
    when 'followers': self.followers
    when 'all': self.all
    else []
    end
  end
  
  def <=>(other_tweeter)
    self.screen_name <=> other_tweeter.screen_name
  end
  
  def ==(other_tweeter)
    self.screen_name == other_tweeter.screen_name
  end
  
  def method_missing(name, *args, &block)
#     puts "Calling #{@tweeter['screen_name']}.#{name}"
    if @tweeter[name.to_s]
#       puts "Returning #{name}: #{@tweeter[name.to_s]}"
      @tweeter[name.to_s]
    else
      super
    end
  end
end
