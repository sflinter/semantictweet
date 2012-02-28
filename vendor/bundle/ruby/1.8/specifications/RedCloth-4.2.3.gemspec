# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "RedCloth"
  s.version = "4.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Garber"]
  s.date = "2010-03-01"
  s.description = "RedCloth-4.2.3 - Textile parser for Ruby.\nhttp://redcloth.org/"
  s.email = "redcloth-upwards@rubyforge.org"
  s.executables = ["redcloth"]
  s.extensions = ["ext/redcloth_scan/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "README"]
  s.files = ["bin/redcloth", "CHANGELOG", "lib/case_sensitive_require/RedCloth.rb", "lib/redcloth/erb_extension.rb", "lib/redcloth/formatters/base.rb", "lib/redcloth/formatters/html.rb", "lib/redcloth/formatters/latex.rb", "lib/redcloth/textile_doc.rb", "lib/redcloth/version.rb", "lib/redcloth.rb", "README", "ext/redcloth_scan/extconf.rb"]
  s.homepage = "http://redcloth.org"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "RedCloth", "--main", "README"]
  s.require_paths = ["lib", "ext", "lib/case_sensitive_require"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = "redcloth"
  s.rubygems_version = "1.8.15"
  s.summary = "RedCloth-4.2.3 - Textile parser for Ruby. http://redcloth.org/"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
