require 'httparty'

class GeoNames
  include HTTParty
  base_uri APP_CONFIG[:geonames][:base_uri]
  
  attr_reader :lat, :lng, :name, :geonameId
  
  # We will cater for a number of types of placenames:
  # 1. Names of the form 'Dublin, Ireland'
  # 2. Names of the form 'France'
  # 3. Names of the form 'iPhone: 51.123,-8.987'
  # 4. Names of the form 'geonames:123456'
  def initialize(location)
    if parse_geoname_location(location)
      return
    else
      parse_lat_lng_location(location)
    end
  end
  
private
  def parse_geoname_location(location)
    if /geonames:(\d*)/ =~ location
      @geonameId = $1
    end
  end
  
  # 3. Names of the form 'iPhone: 51.123,-8.987'
  def parse_lat_lng_location(location)
    if /\D*(-?\d*\.\d*),(-?\d*\.\d*)/ =~ location
      resp = self.class.get("/findNearbyPlaceNameJSON?lat=#{$1}&lng=#{$2}")
      geoname = resp['geonames'].first
      puts "resp.body: #{resp.body}"

      @lat = geoname['lat'].to_f
      @lng = geoname['lng'].to_f
      @name = geoname['name']
      @geonameId = geoname['geonameId'].to_i
    end
  end
end
