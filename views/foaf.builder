helpers do
  def namespaces
    {
      "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "xmlns:rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "xmlns:foaf" => "http://xmlns.com/foaf/0.1/",
      "xmlns:admin" => "http://webns.net/mvcb/"
    }
  end

  def personal_profile_document(xml, person)
    me = rdf_id(person['screen_name'])
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

  def knows(xml, foaf)
    xml.foaf :knows, "rdf:resource" => rdf_id(foaf['screen_name'])
  end
  
  def person(xml, person, foafs = [])
    if person && person['name']
      xml.foaf :Person, "rdf:about" => rdf_id(person['screen_name']) do
        xml.foaf :name, person['name']
        xml.foaf :nick, person['screen_name']
        xml.rdfs :seeAlso, "rdf:resource" => "#{APP_CONFIG[:semantictweet][:base_uri]}/#{person['screen_name']}"
        xml.foaf :homepage, "rdf:resource" => person['url'] if valid_uri?(person['url'])
        xml.foaf :img, "rdf:resource" => person['profile_image_url']
        foafs.each { |foaf| knows(xml, foaf) } if !foafs.empty?
      end
    end
  end
end

xml.rdf :RDF, namespaces do
  personal_profile_document(xml, @twitter.show)
  @foafs.each do |foaf|
    person(xml, foaf)
  end
  person(xml, @twitter.show, @foafs)
end

