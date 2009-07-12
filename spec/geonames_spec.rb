describe 'GeoNames integration' do
  it 'should parse name location' do
    location = "Paris, France"
    geo = GeoNames.new(location)
    geo.lat.should == 53.3095701794021
    geo.lng.should == -6.31271839141846
    geo.name.should == "New York"
    geo.geonameId.should == 123456
  end

  it 'should parse geonames location' do
    location = "geonames:5128581"
    geo = GeoNames.new(location)
    geo.lat.should == 40.7142691
    geo.lng.should == -74.0059729
    geo.name.should == "New York"
    geo.geonameId.should == 5128581
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
  
  it 'should use default location' do
    location = 'Somewhere over the ocean'
    geo = GeoNames.new(location)
    geo.name.should == location
  end
end
