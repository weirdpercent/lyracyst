$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'rake/clean'
require "bundler/version"

task :build do
  system "gem build lyracyst.gemspec"
end

desc "Creates executable in /bin"
task :bin do
  `cp ./lib/lyracyst.rb ./bin/lyracyst`
end

task :clean do
  CLEAN = FileList['**/*.json']
  puts 'JSON cleaned.'
end
task :clobber do
  CLOBBER = FileList['**/*.json']
  puts 'Everything cleaned.'
end
namespace :lyracyst do
  desc "get[searchword]"
  task :get, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    result=''
    s.define(args.search)
    s.related(args.search, result)
    s.rhyme(args.search)
  end

  desc "define[searchword]"
  task :define, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    s.define(args.search)
  end

  desc "related[searchword]"
  task :related, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    result=''
    s.related(args.search, result)
  end

  desc "rhyme[searchword]"
  task :rhyme, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    s.rhyme(args.search)
  end
end
task :default => 'lyracyst:get'
