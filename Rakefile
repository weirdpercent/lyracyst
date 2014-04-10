$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'rake/clean'
require "bundler/version"

task :build do
  system "gem build lyracyst.gemspec"
end

task :release => :build do
  system "gem push lyracyst-#{Bundler::VERSION}"
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
  desc "Get"
  task :get, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    result=''
    s.define(args.search)
    s.related(args.search, result)
    s.rhyme(args.search)
  end

  desc "Define"
  task :define, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    s.define(args.search)
  end

  desc "Related"
  task :related, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    result=''
    s.related(args.search, result)
  end

  desc "Rhymes"
  task :rhyme, :search do |t, args|
    require './lib/lyracyst.rb'
    s=Search.new
    s.rhyme(args.search)
  end
end
task :default => 'lyracyst:get'
