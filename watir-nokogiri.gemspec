# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "watir-nokogiri/version"

Gem::Specification.new do |s|
  s.name        = "watir-nokogiri"
  s.version     = WatirNokogiri::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Ko"]
  s.homepage    = "https://github.com/jkotests/watir-nokogiri"
  s.summary     = %q{Watir HTML parser}
  s.description = %q{Watir-Nokogiri is an HTML parser using Watir's API.}
  
  s.files = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
  s.require_path = "lib"
  
  s.add_dependency "nokogiri"
end
