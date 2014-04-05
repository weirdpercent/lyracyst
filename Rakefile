require 'rake/clean'

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
  task :define do
    require './lib/lyracyst.rb'
    s=Search.new
    s.define(args.search)
  end

  desc "Related"
  task :related do
    require './lib/lyracyst.rb'
    s=Search.new
    result=''
    s.related(args.search, result)
  end

  desc "Rhymes"
  task :rhyme do
    require './lib/lyracyst.rb'
    s=Search.new
    s.rhyme(args.search)
  end
end
task :default => 'lyracyst:get'
