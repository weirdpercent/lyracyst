#!/usr/bin/env ruby
# coding: utf-8
#%w(curb em-synchrony em-http eventmachine excon httpclient httpi net/http/persistent rainbow).map {|lib| require lib}
#%w(json/ext json/pure multi_json oj yajl).map {|lib| require lib}
#%w(libxml multi_xml ox rexml/document).map {|lib| require lib}
require 'gli'
require 'lyracyst/rhymebrain'
require 'lyracyst/urban'
require 'lyracyst/version'
require 'lyracyst/wordnik'
require 'xml-fu'
module Lyracyst

  HTTPI.log = false

  # Optionally sets HTTP adapter with httpi. Supports [:httpclient,
  # :curb, :em_http, :net_http_persistent, :excon, :rack]
  #
  # @param http [Symbol] The http adapter to use. Smart defaults.
  def self.set_http(http)
    HTTPI.adapter = http
  end

  # Optionally sets JSON adapter with multi_json. Supports [:oj,
  # :yajl, :json_gem, :json_pure]
  #
  # @param mj [Symbol] The JSON adapter to use. Smart defaults.
  def self.set_json(mj)
    MultiJson.use(mj)
  end

  # Optionally sets XML adapter with multi_xml. Supports [:ox,
  # :libxml, :nokogiri, :rexml]
  #
  # @param mx [Symbol] The XML adapter to use. Smart defaults.
  def self.set_xml(mx)
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

desc 'Force overwrite'
long_desc 'Overwrites existing JSON & XML files'
switch [:f,:force]

desc 'HTTP adapter'
long_desc 'httpclient, curb, em_http, net_http_persistent, excon, rack'
default_value :net_http_persistent
arg_name 'http'
flag [:h,:http]

desc 'JSON adapter'
long_desc 'oj, yajl, json_gem, json_pure'
default_value :oj
arg_name 'json'
flag [:j,:json]

desc 'Output file'
long_desc 'filename.json or filename.xml'
default_value nil
arg_name 'outfile'
flag [:o,:out]

desc 'XML adapter'
long_desc 'ox, libxml, nokogiri, rexml'
default_value :rexml
arg_name 'xml'
flag [:x,:xml]

desc 'Fetches definitions from Wordnik'
arg_name 'word'
command :define do |c|
  c.desc 'Comma-separated list of parts of speech. See http://developer.wordnik.com/docs.html#!/word/getDefinitions_get_2 for list of parts.'
  c.default_value nil
  c.arg_name 'part'
  c.flag [:p,:part]
  c.desc "Source dictionary to return definitions from. If 'all' is received, results are returned from all sources. If multiple values are received (e.g. 'century,wiktionary'), results are returned from the first specified dictionary that has definitions. If left blank, results are returned from the first dictionary that has definitions. By default, dictionaries are searched in this order: ahd, wiktionary, webster, century, wordnet"
  c.default_value 'all'
  c.arg_name 'defdict'
  c.flag [:defdict]
  c.action do |global_options,options,args|
    # If you have any errors, just raise them
    # raise "that command made no sense"
    search = args[0]
    part = options[:p]
    params = {limit: 10, increl: false, canon: false, inctags: false}
    params[:defdict] = options[:defdict]
    df = Lyracyst::Wordnik::Define.new
    df.get_def(search, part, params)
  end
end

desc 'Fetches examples from Wordnik'
arg_name 'word'
command :example do |c|
  c.desc 'Results to skip'
  c.default_value 0
  c.arg_name 'skip'
  c.flag [:s,:skip]
  c.desc 'Maximum number of results to return'
  c.default_value 5
  c.arg_name 'limit'
  c.flag [:limit]
  c.action do |global_options,options,args|
    search = args[0]
    skip = options[:s]
    limit = options[:limit]
    params = {incdups: false, canon: false}
    params[:skip] = skip
    params[:limit] = limit
    ex = Lyracyst::Wordnik::Example.new
    ex.get_ex(search, params)
  end
end

desc 'Fetches related words from Wordnik'
arg_name 'word'
command :relate do |c|
  c.desc 'Limits the total results per type of relationship type'
  c.default_value nil
  c.arg_name 'reltypes'
  c.flag [:relt]
  c.desc 'Restrict to the supplied relationship types'
  c.default_value 10
  c.arg_name 'rell'
  c.flag [:rell]
  c.action do |global_options,options,args|
    search = args[0]
    reltypes = options[:relt]
    rellimit = options[:rell]
    params = {canon: false}
    params[:rellimit] = rellimit
    ex = Lyracyst::Wordnik::Relate.new
    ex.get_rel(search, params, reltypes)
  end
end

desc 'Fetches pronunciations from Wordnik'
arg_name 'word'
command :pronounce do |c|
  c.desc 'Get from a single dictionary. Valid options: ahd, century, cmu, macmillan, wiktionary, webster, or wordnet'
  c.default_value nil
  c.arg_name 'source'
  c.flag [:src]
  c.desc 'Text pronunciation type'
  c.long_desc 'ahd, arpabet, gcide-diacritical, IPA'
  c.default_value nil
  c.arg_name 'ptype'
  c.flag [:pt]
  c.desc 'Maximum number of results to return'
  c.default_value 5
  c.arg_name 'limit'
  c.flag [:limit]
  c.action do |global_options,options,args|
    search = args[0]
    source = options[:src]
    ptype = options[:pt]
    limit = options[:limit]
    params = {canon: false}
    params[:source] = source
    params[:limit] = limit
    pr = Lyracyst::Wordnik::Pronounce.new
    pr.get_pro(search, params, ptype)
  end
end

desc 'Fetches hyphenation and syllable stresses from Wordnik. Primary stress is red, secondary stress is bright white.'
arg_name 'word'
command :hyphen do |c|
  c.desc "Get from a single dictionary. Valid options: ahd, century, wiktionary, webster, and wordnet."
  c.default_value nil
  c.arg_name 'source'
  c.flag [:src]
  c.desc 'Maximum number of results to return'
  c.default_value 5
  c.arg_name 'limit'
  c.flag [:limit]
  c.action do |global_options,options,args|
    search = args[0]
    source = options[:src]
    limit = options[:limit]
    params = {canon: false}
    if source != nil then params[:source] = source; end
    params[:limit] = limit
    hyph = Lyracyst::Wordnik::Hyphen.new
    hyph.get_hyph(search, params)
  end
end

desc 'Fetches bi-gram phrases from Wordnik'
arg_name 'word'
command :phrase do |c|
  c.desc 'Maximum number of results to return'
  c.default_value 10
  c.arg_name 'limit'
  c.flag [:limit]
  c.desc 'Minimum WLMI(weighted mutual info) for the phrase.'
  c.default_value 13
  c.arg_name 'wlmi'
  c.flag [:wlmi]
  c.action do |global_options,options,args|
    search = args[0]
    limit = options[:limit]
    wlmi = options[:wlmi]
    params = {canon: false}
    params[:limit] = limit
    params[:wlmi] = wlmi
    phra = Lyracyst::Wordnik::Phrase.new
    phra.get_phr(search, params)
  end
end

desc 'Fetches etymologies from Wordnik'
arg_name 'word'
command :origin do |c|
  c.action do |global_options,options,args|
    search = args[0]
    params = {canon: false}
    orig = Lyracyst::Wordnik::Origin.new
    orig.get_et(search, params)
  end
end

desc 'Fetches rhymes from Rhymebrain.com'
arg_name 'word'
command :rhyme do |c|
  c.desc 'ISO639-1 language code (optional). Eg. en, de, es, fr, ru'
  c.default_value 'en'
  c.arg_name 'lang'
  c.flag [:lang]
  c.desc '(optional) The number of results to return. If you do not include this parameter, RhymeBrain will choose how many words to show based on how many good sounding rhymes there are for the word.'
  c.default_value nil
  c.arg_name 'max'
  c.flag [:max]
  c.action do |global_options,options,args|
    search = args[0]
    lang = options[:lang]
    max = options[:max]
    params = {}
    params[:lang] = lang
    params[:max] = max
    rhym = Lyracyst::Rhymebrain::Rhyme.new
    rhym.get_rhyme(search, params)
  end
end

desc 'Fetches word info from Rhymebrain.com'
arg_name 'word'
command :info do |c|
  c.desc 'ISO639-1 language code (optional). Eg. en, de, es, fr, ru'
  c.default_value 'en'
  c.arg_name 'lang'
  c.flag [:lang]
  c.desc '(optional) The number of results to return. If you do not include this parameter, RhymeBrain will choose how many words to show based on how many good sounding rhymes there are for the word.'
  c.default_value nil
  c.arg_name 'max'
  c.flag [:max]
  c.action do |global_options,options,args|
    search = args[0]
    lang = options[:lang]
    max = options[:max]
    params = {}
    params[:lang] = lang
    params[:max] = max
    info = Lyracyst::Rhymebrain::Info.new
    info.get_info(search, params)
  end
end

desc 'Fetches combined words (portmanteaus) from Rhymebrain.com'
arg_name 'word'
  command :combine do |c|
  c.desc 'ISO639-1 language code (optional). Eg. en, de, es, fr, ru'
  c.default_value 'en'
  c.arg_name 'lang'
  c.flag [:lang]
  c.desc '(optional) The number of results to return. If you do not include this parameter, RhymeBrain will choose how many words to show based on how many good sounding rhymes there are for the word.'
  c.default_value nil
  c.arg_name 'max'
  c.flag [:max]
  c.action do |global_options,options,args|
    search = args[0]
    lang = options[:lang]
    max = options[:max]
    params = {}
    params[:lang] = lang
    params[:max] = max
    port = Lyracyst::Rhymebrain::Combine.new
    port.get_port(search, params)
  end
end

desc 'Fetches definitions from Urban Dictionary'
arg_name 'word'
command :urban do |c|
  c.action do |global_options,options,args|
    search = args[0]
    ur = Lyracyst::Urban::Define.new
    ur.get_def(search)
  end
end

pre do |global,command,options,args|
  # Pre logic here
  # Return true to proceed; false to abort and not call the
  # chosen command
  # Use skips_pre before a command to skip this block
  # on that command only
  if global[:o] != nil
    outfile = global[:o]
    if outfile =~ /\w*\.json/
      $fmt = :json
    elsif outfile =~ /\w*.xml/
      $fmt = :xml
    else
      puts 'Invalid file extension.'
    end
    $tofile = []
  end
  http = global[:h]
  json = global[:j]
  xml = global[:x]
  if http.class != Symbol then http = http.to_sym; end
  Lyracyst.set_http(http)
  if json.class != Symbol then json = json.to_sym; end
  Lyracyst.set_json(json)
  if xml.class != Symbol then xml = xml.to_sym; end
  Lyracyst.set_xml(xml)
  label = 'Global options'
  Lyracyst.label(label)
  print "➜#{global}➜"
  label = 'Command'
  Lyracyst.label(label)
  print "➜#{command.name}➜"
  label = 'Command options'
  Lyracyst.label(label)
  print "➜#{options}➜"
  label = 'Args'
  Lyracyst.label(label)
  print "➜#{args}➜"
  label =  'Bootstrapped'
  Lyracyst.label(label)
  puts ''
  true
end

post do |global,command,options,args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
  if $fmt != nil
    outfile = global[:o]
    if File.exist?(outfile) && global[:f] == true
      if $fmt == :json
        fo = File.open(outfile, 'w+')
        fo.print MultiJson.dump($tofile)
        fo.close
      elsif $fmt == :xml
        fo = File.open(outfile, 'w+')
        fo.print '<?xml version="1.0" encoding="utf-8"?>'
        fo.print XmlFu.xml($tofile)
        fo.close
      else
        puts 'Invalid file extension.'
      end
      puts Rainbow("Word search was written to #{outfile}.").bright
    end
    if File.exist?(outfile) && global[:f] == false
      puts Rainbow("#{outfile} exists. Overwrite? y/n ").bright
      ans = gets
      if ans =~ /y/
        if $fmt == :json
          fo = File.open(outfile, 'w+')
          fo.print MultiJson.dump($tofile)
          fo.close
        elsif $fmt == :xml
          fo = File.open(outfile, 'w+')
          fo.print '<?xml version="1.0" encoding="utf-8"?>'
          fo.print XmlFu.xml($tofile)
          fo.close
        else
          puts 'Invalid file extension.'
        end
        puts Rainbow("Word search was written to #{outfile}.").bright
      else
        puts 'Please try again with a different filename.'
      end
    else
      if $fmt == :json
        fo = File.open(outfile, 'w+')
        fo.print MultiJson.dump($tofile)
        fo.close
      elsif $fmt == :xml
        fo = File.open(outfile, 'w+')
        fo.print '<?xml version="1.0" encoding="utf-8"?>'
        fo.print XmlFu.xml($tofile)
        fo.close
      else
        puts 'Invalid file extension.'
      end
      puts Rainbow("Word search was written to #{outfile}.").bright
    end
  end
  label = 'Shutdown'
  Lyracyst.label(label)
  puts ''
end

on_error do |exception|
  # Error logic here
  # return false to skip default error handling
  true
end
exit run(ARGV)
