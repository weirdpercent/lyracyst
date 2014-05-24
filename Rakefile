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
  `gem build lyracyst.gemspec`
end

desc 'Create executable in /bin'
task :bin do
  rl = File.readlines('./lib/lyracyst.rb')
  x, y = 0, rl.length - 1
  while x <= y
    l = rl[x]
    if l =~ /require 'lyracyst\/[a-z]*'/
      s = l.scan(/require '(lyracyst)\/([a-z]*)'/)
      s = s[0]
      pre = "./lib/#{s[0]}"
      suf = "#{s[1]}.rb"
      rl[x] = "require '#{pre}/#{suf}'\n"
    end
    x += 1
  end
  fo = File.open('./bin/lyracyst', "w+")
  fo.print rl.join
  fo.close
  puts 'Built binstub.'
end

namespace :lyracyst do
  desc 'get[searchword]'
  task :get, :search do |t, args|
    search = args.search
    `lyracyst get #{search}`
  end

  desc 'define[searchword]'
  task :define, :search do |t, args|
    search = args.search
    `lyracyst define #{search}`
  end

  desc 'relate[searchword]'
  task :relate, :search do |t, args|
    search = args.search
    `lyracyst relate #{search}`
  end

  desc 'phrase[searchword]'
  task :phrase, :search do |t, args|
    search = args.search
    `lyracyst phrase #{search}`
  end

  desc 'rhyme[searchword]'
  task :rhyme, :search do |t, args|
    search = args.search
    `lyracyst rhyme #{search}`
  end

  desc 'example[searchword]'
  task :example, :search do |t, args|
    search = args.search
    `lyracyst example #{search}`
  end

  desc 'pronounce[searchword]'
  task :pronounce, :search do |t, args|
    search = args.search
    `lyracyst pronounce #{search}`
  end

  desc 'hyphen[searchword]'
  task :hyphen, :search do |t, args|
    search = args.search
    `lyracyst hyphen #{search}`
  end

  desc 'etymology[searchword]'
  task :etymology, :search do |t, args|
    search = args.search
    `lyracyst etymology #{search}`
  end
end

task :travis do
  ["rake features", "rake lyracyst:get[test]"].each do |cmd|
    puts "Starting to run #{cmd}..."
    `bundle exec #{cmd}`
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :default => ':travis'
