# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rack-throttle"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Arto Bendiken", "Brendon Murphy"]
  s.date = "2010-03-21"
  s.description = "Rack middleware for rate-limiting incoming HTTP requests."
  s.email = "arto.bendiken@gmail.com"
  s.homepage = "http://github.com/datagraph"
  s.licenses = ["Public Domain"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.rubyforge_project = "datagraph"
  s.rubygems_version = "1.8.15"
  s.summary = "HTTP request rate limiter for Rack applications."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rack-test>, [">= 0.5.3"])
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<yard>, [">= 0.5.3"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
    else
      s.add_dependency(%q<rack-test>, [">= 0.5.3"])
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<yard>, [">= 0.5.3"])
      s.add_dependency(%q<rack>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<rack-test>, [">= 0.5.3"])
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<yard>, [">= 0.5.3"])
    s.add_dependency(%q<rack>, [">= 1.0.0"])
  end
end
