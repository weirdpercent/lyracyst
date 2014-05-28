$:.unshift File.dirname(__FILE__)
require 'rake/clean'
require "bundler/version"
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc 'Run Spinach'
task :spinach do
  system 'spinach --reporter progress'
end

desc 'Build gemspec'
task :build do
  `gem build lyracyst.gemspec`
  puts 'Built gemfile.'
end

desc 'Create executable in /bin'
task :bin do
  `cp ./lib/lyracyst.rb ./bin/lyracyst`
  puts 'Built binstub.'
end

namespace :lyracyst do

  desc 'combine[searchword]'
  task :combine, :search do |t, args|
    search = args.search
    system "lyracyst combine #{search}"
  end

  desc 'define[searchword]'
  task :define, :search do |t, args|
    search = args.search
    system "lyracyst define #{search}"
  end

  desc 'example[searchword]'
  task :example, :search do |t, args|
    search = args.search
    system "lyracyst example #{search}"
  end

  desc 'hyphen[searchword]'
  task :hyphen, :search do |t, args|
    search = args.search
    system "lyracyst hyphen #{search}"
  end

  desc 'origin[searchword]'
  task :origin, :search do |t, args|
    search = args.search
    system "lyracyst origin #{search}"
  end

  desc 'phrase[searchword]'
  task :phrase, :search do |t, args|
    search = args.search
    system "lyracyst phrase #{search}"
  end

  desc 'pronounce[searchword]'
  task :pronounce, :search do |t, args|
    search = args.search
    system "lyracyst pronounce #{search}"
  end

  desc 'relate[searchword]'
  task :relate, :search do |t, args|
    search = args.search
    system "lyracyst relate #{search}"
  end

  desc 'rhyme[searchword]'
  task :rhyme, :search do |t, args|
    search = args.search
    system "lyracyst rhyme #{search}"
  end

end

task :travis do
  ['rake spinach', 'rake lyracyst:combine[test]', 'rake lyracyst:define[test]', 'rake lyracyst:example[test]', 'rake lyracyst:hyphen[communication]', 'rake lyracyst:origin[test]', 'rake lyracyst:phrase[test]', 'rake lyracyst:pronounce[beautiful]', 'rake lyracyst:relate[test]', 'rake lyracyst:rhyme[test]'].each do |cmd|
    puts "Starting to run #{cmd}..."
    `bundle exec #{cmd}`
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :default => ':travis'
