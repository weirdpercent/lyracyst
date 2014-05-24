require 'aruba/cucumber'
require 'methadone/cucumber'
require 'rspec/expectations'
require 'spinach'
require 'coveralls'

Coveralls.wear!
PROJECT_ROOT = File.join(File.dirname(__FILE__),'..','..')
ENV['PATH'] = "#{File.join(PROJECT_ROOT,'bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')
ARUBA_DIR = File.join(%w(tmp aruba))

#Spinach.hooks.before_scenario do |scenario|
#  @dirs = [ARUBA_DIR]
#  @puts = true
#  @aruba_timeout_seconds = 60
#  @original_rubylib = ENV['RUBYLIB']
#  @original_rubyopt = ENV['RUBYOPT']
#  ENV['RUBYLIB'] = File.join(PROJECT_ROOT,'lib') + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
#  ENV['RUBYOPT'] = (ENV['RUBYOPT'] || '') + ' -rubygems'
#end

#Spinach.hooks.after_run do |status|
#  ENV['RUBYLIB'] = @original_rubylib
#  ENV['RUBYOPT'] = @original_rubyopt
#  puts "Exited with #{status}"
#end

Before do
  @dirs = [ARUBA_DIR]
  @puts = true
  @aruba_timeout_seconds = 60
  @original_rubylib = ENV['RUBYLIB']
  @original_rubyopt = ENV['RUBYOPT']
  ENV['RUBYLIB'] = File.join(PROJECT_ROOT,'lib') + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
  ENV['RUBYOPT'] = (ENV['RUBYOPT'] || '') + ' -rubygems'
end

After do
  ENV['RUBYLIB'] = @original_rubylib
  ENV['RUBYOPT'] = @original_rubyopt
end
