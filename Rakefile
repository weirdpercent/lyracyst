# Query parameters are preceded by a question mark ("?") and separated by ampersands ("&") and consist of the parameter name,
# an equals sign ("="), and a value.
# Each thesaurus.altervista.org application can perform upto 5000 queries per day.
require 'rake/clean'

task :clean do
  CLEAN = FileList['**/*.json']
  puts 'JSON cleaned.'
end

task :clobber do
  CLOBBER = FileList['**/*.json']
  puts 'Everything cleaned.'
end

desc "Run"
task :run do
  require './lib/lyracyst.rb'
end

task :default => :run
