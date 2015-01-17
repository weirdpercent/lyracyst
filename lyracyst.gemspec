# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'lyracyst/version'

Gem::Specification.new do |s|
  s.name        = "lyracyst"
  s.version     = Lyracyst::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Drew Prentice"
  s.email       = "weirdpercent@gmail.com"
  s.homepage    = "http://github.com/weirdpercent/lyracyst"
  s.summary     = %q{A powerful word search tool.}
  s.description = %q{Search multiple word APIs from the command line.}
  s.license     = "MIT"
  s.post_install_message = "Thanks for using lyracyst!\nPlease get necessary API keys as shown in:\nhttp://github.com/weirdpercent/lyracyst"

  # If you have other dependencies, add them here
  s.add_runtime_dependency "gli", "~> 2.12"
  s.add_runtime_dependency "httpi", "~> 2.3"
  s.add_runtime_dependency "metainspector", "~> 4.1"
  s.add_runtime_dependency "multi_json", "~> 1.10"
  s.add_runtime_dependency "multi_xml", "~> 0.5"
	s.add_runtime_dependency "nokogiri", "~> 1.6"
  s.add_runtime_dependency "rainbow", "~> 2.0"
  s.add_runtime_dependency "rubyntlm", "~> 0.4"
  s.add_runtime_dependency "xml-fu", "~> 0.2"
  s.add_development_dependency "aruba", "~> 0.6"
  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "coveralls", "~> 0.7"
  s.add_development_dependency "rake", "~> 10.4"
  s.add_development_dependency "spinach", "~> 0.8"
  s.add_development_dependency "yard", "~> 0.8"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "json/*","CHANGELOG.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["lyracyst"]
end
