$:.unshift File.dirname(__FILE__)
require 'rake/clean'
require "bundler/version"

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

  desc 'comb[searchword]'
  task :comb, :search do |t, args|
    search = args.search
    system "lyracyst rb comb #{search}"
  end

  desc 'def[searchword]'
  task :def, :search do |t, args|
    search = args.search
    system "lyracyst wn def #{search}"
  end

  desc 'ex[searchword]'
  task :ex, :search do |t, args|
    search = args.search
    system "lyracyst wn ex #{search}"
  end

  desc 'hyph[searchword]'
  task :hyph, :search do |t, args|
    search = args.search
    system "lyracyst wn hyp #{search}"
  end

  desc 'inf[searchword]'
  task :inf, :search do |t, args|
    search = args.search
    system "lyracyst rb inf #{search}"
  end

  desc 'look[searchword]'
  task :look, :search do |t, args|
    search = args.search
    system "lyracyst look #{search}"
  end

  desc 'ori[searchword]'
  task :ori, :search do |t, args|
    search = args.search
    system "lyracyst wn ori #{search}"
  end

  desc 'phr[searchword]'
  task :phr, :search do |t, args|
    search = args.search
    system "lyracyst wn phr #{search}"
  end

  desc 'pro[searchword]'
  task :pro, :search do |t, args|
    search = args.search
    system "lyracyst wn pro #{search}"
  end

  desc 'rel[searchword]'
  task :rel, :search do |t, args|
    search = args.search
    system "lyracyst wn rel #{search}"
  end

  desc 'rhy[searchword]'
  task :rhy, :search do |t, args|
    search = args.search
    system "lyracyst rb rhy #{search}"
  end

  desc 'urb[searchword]'
  task :urb, :search do |t, args|
    search = args.search
    system "lyracyst urb #{search}"
  end

end

task :travis do
  ['rake spinach', 'rake lyracyst:comb[test]', 'rake lyracyst:def[test]', 'rake lyracyst:ex[test]', 'rake lyracyst:hyph[communication]', 'rake lyracyst:inf[fuck]', 'rake lyracyst:look[test]', 'rake lyracyst:ori[test]', 'rake lyracyst:phr[test]', 'rake lyracyst:pro[beautiful]', 'rake lyracyst:rel[test]', 'rake lyracyst:rhy[test]', 'rake lyracyst:urb[hashtag]'].each do |cmd|
    puts "Starting to run #{cmd}..."
    `bundle exec #{cmd}`
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :default => ':travis'
