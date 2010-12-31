require 'pp'
require 'geonames'

class Tweeter
  include Comparable

  attr_reader :foafs, :geoname

  def initialize(client, tweeter, who = 'friends')
    @foafs = []
    @client = client

    case tweeter
    when String
      @given_screen_name = URI.escape(tweeter)
      puts "@given_screen_name: #{@given_screen_name}"
      @tweeter = self.show
      if self.exists?
        foafs = self.who(who)
        @foafs = foafs.map { |foaf| Tweeter.new(@client, foaf) }
        # @geoname = GeoNames.new(@tweeter['location']) unless @tweeter['location'].blank?
      end
    when Hash
      @tweeter = tweeter
    end

    # This is somewhat of an ugly hack. The alternative is to put this
    # logic in method_missing()
    @tweeter['url'] = '' unless @tweeter['url']
  end

  def exists(resp)
    @exists = resp['error'] != 'Not found'
  end

  def exists?
    @exists
  end

  def show
    puts "Calling @client.show(#{@given_screen_name})"
    resp = @client.show(@given_screen_name)
    exists(resp)
    resp
  end

  def friends
    puts "Calling @client.friends(#{@given_screen_name})"
    resp = @client.friends(@given_screen_name)['users']
    # puts resp.to_yaml
    resp
  end

  def followers
    puts "Calling @client.followers(#{@given_screen_name})"
    resp = @client.followers(@given_screen_name)['users']
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
