require File.expand_path("../lib/lyracyst", __FILE__)

Gem::Specification.new do |s|
  s.name        = "lyracyst"
  s.version     = "0.0.4"
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["Drew Prentice"]
  s.email       = ["weirdpercent@gmail.com"]
  s.homepage    = "http://github.com/weirdpercent/lyracyst"
  s.summary     = "A powerful word search tool that fetches definitions, related words, and rhymes. "
  s.description = "Search Wordnik, thesaurus.altervista.org, and Arpabet from the command line."
  s.required_rubygems_version = ">= 2.2.2"

  # If you have other dependencies, add them here
  s.add_runtime_dependency "commander", "~> 4.1"
  s.add_runtime_dependency "multi_json", "~> 1.9"
  s.add_runtime_dependency "open-uri-cached", "~> 0.0"
  s.add_runtime_dependency "wordnik", "~> 4.12"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "license.md", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["lyracyst"]
end
