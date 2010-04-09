require 'uri'

helpers do
  def namespaces
    {
      "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "xmlns:rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "xmlns:foaf" => "http://xmlns.com/foaf/0.1/",
      "xmlns:admin" => "http://webns.net/mvcb/",
      "xmlns:skos" => "http://www.w3.org/2008/05/skos",
      "xmlns:dc" => "http://purl.org/dc/elements/1.1/"
    }
  end

  def personal_profile_document(xml)
    xml.foaf :PersonalProfileDocument, "rdf:about" => "" do
      xml.foaf :maker, "rdf:resource" => "#{APP_CONFIG[:semantictweet][:base_uri]}/semantictweet"
      xml.admin :generatorAgent, "rdf:resource" => APP_CONFIG[:semantictweet][:generator_agent]
      xml.admin :errorReportsTo, "rdf:resource" => APP_CONFIG[:semantictweet][:error_reports_to]
    end
  end

  def skosConcept(xml, tags)
    uritags = URI.escape(tags.join('+'))
    xml.skos :Concept, "rdf:about" => "#{APP_CONFIG[:semantictweet][:base_uri]}/tags/#{uritags}" do
      xml.skos :prefLabel, tags.join(' ')
      [ "", ".atom", ".json" ].each do |format|
        xml.rdfs :seeAlso, "rdf:resource" => "#{APP_CONFIG[:twitter][:search_uri]}/#{APP_CONFIG[:twitter][:api_version]}/search#{format}?q=#{uritags}"
      end
    end
  end
  
  def foafDocument(xml, tags)
    uritags = URI.escape(tags.join('+'))
    xml.foaf :Document, "rdf:about" => "#{APP_CONFIG[:twitter][:search_uri]}/#{APP_CONFIG[:twitter][:api_version]}/search?q=#{uritags}" do
      xml.dc :format, "text/html"
    end
  end
end

xml.rdf :RDF, namespaces do
  personal_profile_document(xml)
  skosConcept(xml, @tags)
  foafDocument(xml, @tags)
end

