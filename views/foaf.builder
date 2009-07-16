helpers do
  def namespaces
    {
      "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "xmlns:rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "xmlns:foaf" => "http://xmlns.com/foaf/0.1/",
      "xmlns:admin" => "http://webns.net/mvcb/",
      "xmlns:wgs84_pos" => "http://www.w3.org/2003/01/geo/wgs84_pos#",
      "xmlns:geo" => "http://www.geonames.org/ontology#"
    }
  end

  def personal_profile_document(xml, tweeter)
    me = rdf_id(tweeter.screen_name)
    xml.foaf :PersonalProfileDocument, "rdf:about" => "" do
      xml.foaf :maker, "rdf:resource" => "#{APP_CONFIG[:semantictweet][:base_uri]}/semantictweet"
      xml.foaf :primaryTopic, "rdf:resource" => me
      xml.admin :generatorAgent, "rdf:resource" => APP_CONFIG[:semantictweet][:generator_agent]
      xml.admin :errorReportsTo, "rdf:resource" => APP_CONFIG[:semantictweet][:error_reports_to]
    end
  end

  def rdf_id(id = "")
    "#{APP_CONFIG[:semantictweet][:base_uri]}/#{id}#me"
  end

  def knows(xml, tweeter)
    xml.foaf :knows, "rdf:resource" => rdf_id(tweeter.screen_name)
  end
  
  def based_near(xml, geoname)
    xml.foaf :based_near do
      xml.wgs84_pos :Point do
        xml.foaf :name, geoname.name
        xml.wgs84_pos :lat, geoname.lat
        xml.wgs84_pos :long, geoname.lng
      end
    end
    xml.foaf :based_near, "rdf:resource" => geoname.geonameUri
  end
  
  def person(xml, tweeter)
    if tweeter && tweeter.name
      xml.foaf :Person, "rdf:about" => rdf_id(tweeter.screen_name) do
        xml.foaf :name, tweeter.name
        xml.foaf :nick, tweeter.screen_name
        xml.rdfs :seeAlso, "rdf:resource" => "#{APP_CONFIG[:semantictweet][:base_uri]}/#{tweeter.screen_name}"
        xml.foaf :homepage, "rdf:resource" => tweeter.url if valid_uri?(tweeter.url)
        xml.foaf :img, "rdf:resource" => tweeter.profile_image_url
        based_near(xml, tweeter.geoname) if tweeter.geoname
        tweeter.foafs.each { |foaf| knows(xml, foaf) } #if !person.foafs.empty?
      end
    end
  end
end

xml.rdf :RDF, namespaces do
  personal_profile_document(xml, @tweeter)
  @tweeter.foafs.each { |tweeter| person(xml, tweeter) }
  person(xml, @tweeter)
end

