helpers do
  def namespaces
    {
      "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "xmlns:rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "xmlns:foaf" => "http://xmlns.com/foaf/0.1/",
      "xmlns:admin" => "http://webns.net/mvcb/",
      "xmlns:geo" => "http://www.w3.org/2003/01/geo/wgs84_pos#"
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
  
  def person(xml, tweeter)
    if tweeter && tweeter.name
      xml.foaf :Person, "rdf:about" => rdf_id(tweeter.screen_name) do
        xml.foaf :name, tweeter.name
        xml.foaf :nick, tweeter.screen_name
        xml.rdfs :seeAlso, "rdf:resource" => "#{APP_CONFIG[:semantictweet][:base_uri]}/#{tweeter.screen_name}"
        xml.foaf :homepage, "rdf:resource" => tweeter.url if valid_uri?(tweeter.url)
        xml.foaf :img, "rdf:resource" => tweeter.profile_image_url
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

