helpers do
  def namespaces
    {
      "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "xmlns:rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "xmlns:foaf" => "http://xmlns.com/foaf/0.1/",
      "xmlns:admin" => "http://webns.net/mvcb/"
    }
  end

  def personal_profile_document(xml)
    xml.foaf :PersonalProfileDocument, "rdf:about" => "" do
      xml.foaf :maker, "rdf:resource" => "#me"
      xml.foaf :primaryTopic, "rdf:resource" => "#me"
      xml.admin :generatorAgent, "rdf:resource" => "http://semantictweet.com"
      xml.admin :errorReportsTo, "rdf:resource" => "mailto:stephen@flinter.com"
    end
  end

  def person(xml, person, id = "", knows = [])
    rdf_id = id.blank? ? { } : { "rdf:ID" => id }
    if person && person['name']
      xml.foaf :Person, rdf_id do
        xml.foaf :name, person['name']
        xml.foaf :nick, person['screen_name']
        xml.rdfs :seeAlso, "rdf:resource" => "#{BASE_URL}/#{person['screen_name']}"
        xml.foaf :homepage, "rdf:resource" => person['url'] if valid_uri?(person['url'])
        xml.foaf :img, "rdf:resource" => person['profile_image_url']

        knows.each do |friend|
          xml.foaf :knows do
            self.person(xml, friend)
          end
        end
      end
    end
  end
end

xml.rdf :RDF, namespaces do
  personal_profile_document(xml)
  person(xml, @twitter.show, "me", @twitter.friends)
end

