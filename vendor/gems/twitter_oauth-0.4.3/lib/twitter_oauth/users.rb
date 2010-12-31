module TwitterOAuth
  class Client
    def users_lookup(user_ids)
      get("/users/lookup.json?user_id=#{user_ids.join(',')}")
    end
  end
end