require 'httparty'
require 'pp'
require 'uri'

class GeoNames
  include HTTParty
  base_uri APP_CONFIG[:geonames][:base_uri]
  
  attr_reader :lat, :lng, :name, :geonameId
  
  # We will cater for a number of types of placenames:
  # 1. Names of the form 'geonames:123456'
  # 2. Names of the form 'iPhone: 51.123,-8.987'
  # 3. Names of the form 'Dublin'
  # 4. Names of the form 'Dublin, Ireland'
  def initialize(location)
    # Setup the default geoname
    @lat = 0
    @lng = 0
    @name = location
    @geonameId = 0
    
    case location
    when /geonames:(\d+)/ # e.g. geonames:123456
      parse_geonameId($1)
    when /\D*(-?\d+\.\d+),(-?\d+\.\d+)/ # e.g. iPhone: 51.123,-8.987
      parse_lat_lng($1, $2)
    when /(\D+),\s*(\D+)/ # e.g. Dublin, Ireland
      parse_biname($1, $2)
    else
      parse_name(location)
    end
  end
  
  def geonameUri
    "http://#{APP_CONFIG[:geonames][:sws_base_uri]}/#{@geonameId}/"
  end

private
  def parse_geonameId(geonameId)
    begin
      resp = HTTParty.get(URI.encode("http://#{APP_CONFIG[:geonames][:sws_base_uri]}/#{geonameId}/about.rdf"), :format => :xml)
      feature = resp['rdf:RDF']['Feature']
      @name = feature['name']
      @lat = feature['wgs84_pos:lat'].to_f
      @lng = feature['wgs84_pos:long'].to_f
      @geonameId = geonameId.to_i
    rescue REXML::ParseException
      # This happens when an invalid geoname ID is passed
      p "Invalid geoname ID: #{geonameId}"
    end
  end
  
  def parse_lat_lng(lat, lng)
    resp = self.class.get(URI.encode("/findNearbyPlaceNameJSON?lat=#{lat}&lng=#{lng}"))
    parse_geoname(resp['geonames'].first)
  end
  
  def parse_biname(city, country)
    resp = self.class.get(URI.encode("/searchJSON?name=#{city}&country=#{country}&featureClass=P&maxRows=1"))
    parse_geoname(resp['geonames'].first) if resp['totalResultsCount'].to_i > 0
  end
  
  def parse_name(name)
    resp = self.class.get(URI.encode("/searchJSON?name=#{name}&featureClass=P&maxRows=1"))
    parse_geoname(resp['geonames'].first) if resp['totalResultsCount'].to_i > 0
  end
  
  def parse_geoname(geoname)
    @name = geoname['name']
    @lat = geoname['lat'].to_f
    @lng = geoname['lng'].to_f
    @geonameId = geoname['geonameId'].to_i
  end
end
