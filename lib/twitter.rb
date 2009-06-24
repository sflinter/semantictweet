require 'httparty'

class Twitter
  include HTTParty
  base_uri 'twitter.com'
  
  def initialize(screen_name='')
    @screen_name = screen_name
  end
  
  def exists?
    response = self.class.get("/users/show.json?screen_name=#{@screen_name}")
    response.code.between?(200,299)
  end
  
  def show
    self.class.get("/users/show.json?screen_name=#{@screen_name}")
  end
  
  def friends
    self.class.get("/statuses/friends/#{@screen_name}.json")
  end
  
  def followers
    self.class.get("/statuses/followers/#{@screen_name}.json")
  end
  
  def knows
    (self.friends << self.followers).flatten.uniq
  end
end
