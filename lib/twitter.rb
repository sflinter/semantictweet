require 'httparty'
require 'uri'

class Twitter
  include HTTParty
  base_uri APP_CONFIG[:twitter][:base_uri]
  basic_auth APP_CONFIG[:twitter][:basic_auth_username], APP_CONFIG[:twitter][:basic_auth_password]
  
  def initialize(screen_name='')
    @screen_name = URI.escape(screen_name)
  end
  
  def exists?
    response = self.class.get("/users/show.json?screen_name=#{@screen_name}")
    response.code.between?(200,299)
  end
  
  def show
    self.class.get("/users/show.json?screen_name=#{@screen_name}")
  end
  
  def friends
#     response = self.class.get("/statuses/friends/#{@screen_name}.json")
#     puts "#{@screen_name} has #{response.body.size} friends"
#     response.body
    self.class.get("/statuses/friends/#{@screen_name}.json")
  end
  
  def followers
#     response = self.class.get("/statuses/followers/#{@screen_name}.json")
#     puts "#{@screen_name} has #{response.body.size} followers"
#     response.body
    self.class.get("/statuses/followers/#{@screen_name}.json")
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
end
