describe 'GeoNames integration' do
  it 'should parse Paris' do
    location = "Paris"
    geo = GeoNames.new(location)
    geo.lat.should == 48.85341
    geo.lng.should == 2.3488
    geo.name.should == "Paris"
    geo.geonameId.should == 2988507
  end

  it 'should parse Paris, FR' do
    location = "Paris, FR"
    geo = GeoNames.new(location)
    geo.lat.should == 48.85341
    geo.lng.should == 2.3488
    geo.name.should == "Paris"
    geo.geonameId.should == 2988507
  end

  it 'should parse geonames location' do
    location = "geonames:5128581"
    geo = GeoNames.new(location)
    geo.lat.should == 40.7142691
    geo.lng.should == -74.0059729
    geo.name.should == "New York"
    geo.geonameId.should == 5128581
  end
  
  it 'should handle unknown geoname' do
    location = 'geonames:1234567890'
    geo = GeoNames.new(location)
    geo.lat.should == 0
    geo.lng.should == 0
    geo.name.should == location
    geo.geonameId.should == 0
  end
  
  it 'should parse lat/lng location' do
    lat = 53.306633
    lng = -6.313141
    location = "iPhone: #{lat},#{lng}"
    geo = GeoNames.new(location)
    geo.lat.should == 53.3095701794021
    geo.lng.should == -6.31271839141846
    geo.name.should == "Manor Grove"
    geo.geonameId.should == 6691015
  end
  
  it 'should handle invalid lat/lng location' do
    lat = 200
    lng = 200
    location = "iPhone: #{lat},#{lng}"
    geo = GeoNames.new(location)
    geo.lat.should == 0
    geo.lng.should == 0
    geo.name.should == location
    geo.geonameId.should == 0
  end
  
  it 'should use default location' do
    location = 'Somewhere over the ocean'
    geo = GeoNames.new(location)
    geo.name.should == location
  end
end
