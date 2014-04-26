$:.unshift File.dirname(__FILE__)
require 'rake/clean'
require "bundler/version"
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc 'Build gemspec'
task :build do
  system "gem build lyracyst.gemspec"
end

desc 'Create executable in /bin'
task :bin do
  `cp ./lib/lyracyst.rb ./bin/lyracyst`
end

namespace :lyracyst do
  desc 'get[searchword]'
  task :get, :search do |t, args|
    search = args.search
    system "lyracyst get test"
  end

  desc 'define[searchword]'
  task :define, :search do |t, args|
    search = args.search
    system('lyracyst get test')
  end

  desc 'related[searchword]'
  task :related, :search do |t, args|
    search = args.search
    system('lyracyst get test')
  end

  desc 'rhyme[searchword]'
  task :rhyme, :search do |t, args|
    search = args.search
    system('lyracyst get test')
  end
end

task :travis do
  ["rake features", "rake lyracyst:get[test]"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :default => 'lyracyst:get'
