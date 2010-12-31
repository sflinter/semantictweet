module TwitterOAuth
  class Client
     
    # Returns the 100 last friends
    # The page parameter is implemented for legacy reasons, but use of this is slow
    # as passing page is no longer supported by the Twitter API as the use of cursors
    # is now obligitory. It is recommended that you use all_friends instead
    def friends(screen_name, cursor="-1")
      users = []
      return [] if cursor == 0 
      get("/statuses/friends/#{screen_name}.json?cursor=#{cursor}")
    end 

    # Returns all pages of friends
    def all_friends
      users = []
      cursor = "-1"
      while cursor != 0 do 
        json = get("/statuses/friends.json?cursor=#{cursor}")
        cursor = json["next_cursor"]
        users += json["users"]
      end
      users
    end
    
    # Returns the 100 last followers
    def followers(screen_name,cursor="-1")
      users = []
      return [] if cursor == 0 
      get("/statuses/followers/#{screen_name}.json?cursor=#{cursor}")
    end 

    # Returns all pages of followers
    def all_followers
      users = []
      cursor = "-1"
      while cursor != 0 do 
        json = get("/statuses/followers.json?cursor=#{cursor}")
        cursor = json["next_cursor"]
        users += json["users"]
      end
      users
    end

  end
end
