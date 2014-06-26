#!/usr/bin/env ruby
# coding: utf-8
# %w(curb em-synchrony em-http eventmachine excon httpclient httpi net/http/persistent rainbow).map { |lib| require lib }
# %w(json/ext json/pure multi_json oj yajl).map { |lib| require lib }
# %w(libxml multi_xml ox rexml/document).map { |lib| require lib }
require 'gli'
require 'httpi'
require 'lyracyst/onelook'
require 'lyracyst/rhymebrain'
require 'lyracyst/urban'
require 'lyracyst/version'
require 'lyracyst/wordnik'
require 'lyracyst/wordsmith'
require 'xml-fu'

# The Lyracyst module handles base functionality.
module Lyracyst
  HTTPI.log = false

  # Optionally sets HTTP adapter with httpi. Supports [:httpclient,
  # :curb, :em_http, :net_http_persistent, :excon, :rack]
  #
  # @param http [Symbol] The http adapter to use. Smart defaults.
  def self.http(http)
    HTTPI.adapter = http
  end

  # Optionally sets JSON adapter with multi_json. Supports [:oj,
  # :yajl, :json_gem, :json_pure]
  #
  # @param mj [Symbol] The JSON adapter to use. Smart defaults.
  def self.json(mj)
    MultiJson.use(mj)
  end

  # Optionally sets XML adapter with multi_xml. Supports [:ox,
  # :libxml, :nokogiri, :rexml]
  #
  # @param mx [Symbol] The XML adapter to use. Smart defaults.
  def self.xml(mx)
    MultiXml.parser = mx
  end

  # Prints colored element label.
  #
  # @param label [String] The label to print
  def self.label(label)
    print Rainbow('[').blue.bright
    print Rainbow(label).green.bright
    print Rainbow(']').blue.bright
    print Rainbow('|').bright
  end

  # Adds an object to the outfile array.
  #
  # @param obj [String] The item to add
  def self.tofile(obj)
    if $fmt != nil
      $tofile.push obj
    end
  end
end

include GLI::App
program_desc 'A powerful word search tool that fetches definitions, related words, rhymes, and much more. Rhymes are provided by rhymebrain.com.'
config_file '.lyracyst.yml'
version Lyracyst::VERSION

flag [:h, :http], :default_value => nil, :arg_name => 'string', :desc => 'HTTP adapter', :long_desc => 'httpclient, curb, em_http, net_http_persistent, excon, rack'
flag [:j, :json], :default_value => nil, :arg_name => 'string', :desc => 'JSON adapter', :long_desc => 'oj, yajl, json_gem, json_pure'
flag [:o, :out], :default_value => nil, :arg_name => 'filename', :desc => 'Output file', :long_desc => 'filename.json or filename.xml'
flag [:x, :xml], :default_value => nil, :arg_name => 'string', :desc => 'XML adapter', :long_desc => 'ox, libxml, nokogiri, rexml'
switch [:fo, :force], :default_value => false, :desc => 'Force overwrite', :long_desc => 'Overwrites existing JSON & XML files'
switch [:v, :verbose], :default_value => false, :desc => 'Prints parameters and options'

require 'lyracyst/cli/onelook'
require 'lyracyst/cli/rhymebrain'
require 'lyracyst/cli/urban'
require 'lyracyst/cli/wordnik'
require 'lyracyst/cli/wordsmith'

pre do |global, command, options, args|
  # Pre logic here
  # Return true to proceed; false to abort and not call the
  # chosen command
  # Use skips_pre before a command to skip this block
  # on that command only
  if global[:o] != nil
    outfile = global[:o]
    if outfile =~ /\w*\.json/
      $fmt = :json
    elsif outfile =~ /\w*\.xml/
      $fmt = :xml
    else
      puts 'Invalid file extension.'
    end
    $tofile = []
  end
  http = global[:h]
  json = global[:j]
  xml = global[:x]
  if http != nil
    if http.class != Symbol then http = http.to_sym; end
    Lyracyst.http(http)
  end
  if json != nil
    if json.class != Symbol then json = json.to_sym; end
    Lyracyst.json(json)
  end
  if xml != nil
    if xml.class != Symbol then xml = xml.to_sym; end
    Lyracyst.xml(xml)
  end
  if global[:v]
    Lyracyst.label('Global options')
    print "#{global}"
    Lyracyst.label('Command')
    print "#{command.name}"
    Lyracyst.label('Command options')
    print "#{options}"
    Lyracyst.label('Args')
    print "#{args}"
    Lyracyst.label('Bootstrapped')
    puts ''
  end
  true
end

post do |global, command, options, args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
  if $fmt != nil
    outfile = global[:o]
    if File.exist?(outfile) && global[:fo] == true
      if $fmt == :json
        fo = File.new(outfile, 'w+')
        fo.print MultiJson.dump($tofile, :pretty => true)
        fo.close
        puts Rainbow("Word search was written to #{outfile}.").bright
      elsif $fmt == :xml
        fo = File.new(outfile, 'w+')
        fo.print '<?xml version="1.0" encoding="utf-8"?>'
        fo.print XmlFu.xml($tofile)
        fo.close
        puts Rainbow("Word search was written to #{outfile}.").bright
      else
        puts 'Invalid file extension.'
      end
    end
    if File.exist?(outfile) && global[:fo] == false
      puts Rainbow("#{outfile} exists. Overwrite? y/n ").bright
      ans = gets
      if ans =~ /y/
        if $fmt == :json
          fo = File.new(outfile, 'w+')
          fo.print MultiJson.dump($tofile, :pretty => true)
          fo.close
          puts Rainbow("Word search was written to #{outfile}.").bright
        elsif $fmt == :xml
          fo = File.new(outfile, 'w+')
          fo.print '<?xml version="1.0" encoding="utf-8"?>'
          fo.print XmlFu.xml($tofile)
          fo.close
          puts Rainbow("Word search was written to #{outfile}.").bright
        else
          puts 'Invalid file extension.'
        end
      else
        puts 'Please try again with a different filename.'
      end
    else
      if $fmt == :json
        fo = File.open(outfile, 'w+')
        fo.print MultiJson.dump($tofile, :pretty => true)
        fo.close
        puts Rainbow("Word search was written to #{outfile}.").bright
      elsif $fmt == :xml
        fo = File.open(outfile, 'w+')
        fo.print '<?xml version="1.0" encoding="utf-8"?>'
        fo.print XmlFu.xml($tofile)
        fo.close
        puts Rainbow("Word search was written to #{outfile}.").bright
      else
        puts 'Invalid file extension.'
      end
    end
  end
  if global[:v]
    Lyracyst.label('Shutdown')
    puts ''
  end
end

on_error do |exception|
  # Error logic here
  # return false to skip default error handling
  true
end
exit run(ARGV)
