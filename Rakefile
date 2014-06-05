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
    system "lyracyst rbrain combine #{search}"
  end

  desc 'define[searchword]'
  task :define, :search do |t, args|
    search = args.search
    system "lyracyst wordnik define #{search}"
  end

  desc 'example[searchword]'
  task :example, :search do |t, args|
    search = args.search
    system "lyracyst wordnik example #{search}"
  end

  desc 'hyphen[searchword]'
  task :hyphen, :search do |t, args|
    search = args.search
    system "lyracyst wordnik hyphen #{search}"
  end

  desc 'info[searchword]'
  task :info, :search do |t, args|
    search = args.search
    system "lyracyst info #{search}"
  end

  desc 'origin[searchword]'
  task :origin, :search do |t, args|
    search = args.search
    system "lyracyst wordnik origin #{search}"
  end

  desc 'phrase[searchword]'
  task :phrase, :search do |t, args|
    search = args.search
    system "lyracyst wordnik phrase #{search}"
  end

  desc 'pronounce[searchword]'
  task :pronounce, :search do |t, args|
    search = args.search
    system "lyracyst wordnik pronounce #{search}"
  end

  desc 'relate[searchword]'
  task :relate, :search do |t, args|
    search = args.search
    system "lyracyst wordnik wordnik relate #{search}"
  end

  desc 'rhyme[searchword]'
  task :rhyme, :search do |t, args|
    search = args.search
    system "lyracyst rbrain rhyme #{search}"
  end

  desc 'urban[searchword]'
  task :urban, :search do |t, args|
    search = args.search
    system "lyracyst urban #{search}"
  end

end

task :travis do
  ['rake spinach', 'rake lyracyst:combine[test]', 'rake lyracyst:define[test]', 'rake lyracyst:example[test]', 'rake lyracyst:hyphen[communication]', 'rake lyracyst:info[fuck]', 'rake lyracyst:origin[test]', 'rake lyracyst:phrase[test]', 'rake lyracyst:pronounce[beautiful]', 'rake lyracyst:relate[test]', 'rake lyracyst:rhyme[test]', 'rake lyracyst:urban[hashtag]'].each do |cmd|
    puts "Starting to run #{cmd}..."
    `bundle exec #{cmd}`
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :default => ':travis'
