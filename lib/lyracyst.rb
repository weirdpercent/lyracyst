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

flag [:fmt, :format], :default_value => nil, :arg_name => 'fmt', :desc => 'File format', :long_desc => 'json or xml'
flag [:h, :http], :default_value => :net_http_persistent, :arg_name => 'http', :desc => 'HTTP adapter', :long_desc => 'httpclient, curb, em_http, net_http_persistent, excon, rack'
flag [:j, :json], :default_value => :oj, :arg_name => 'json', :desc => 'JSON adapter', :long_desc => 'oj, yajl, json_gem, json_pure'
flag [:o, :out], :default_value => nil, :arg_name => 'outfile', :desc => 'Output file', :long_desc => 'filename.json or filename.xml'
flag [:x, :xml], :default_value => :rexml, :arg_name => 'xml', :desc => 'XML adapter', :long_desc => 'ox, libxml, nokogiri, rexml'
switch [:f, :force], :default_value => false, :desc => 'Force overwrite', :long_desc => 'Overwrites existing JSON & XML files'

desc 'Wordnik operations'
arg_name 'wordnik'
command :wordnik do |nik|
  nik.switch :canon, :default_value => false, :desc => 'Use canonical', :long_desc => "If true will try to return the correct word root ('cats' -> 'cat'). If false returns exactly what was requested."
  nik.flag :limit, :default_value => 5, :arg_name => 'limit', :desc => 'Maximum number of results to return'
  nik.desc 'Fetch definitions from Wordnik'
  nik.arg_name 'define'
  nik.command :define do |define|
    define.flag :defdict, :default_value => 'all', :arg_name => 'defdict', :desc => "Source dictionary to return definitions from. If 'all' is received, results are returned from all sources. If multiple values are received (e.g. 'century,wiktionary'), results are returned from the first specified dictionary that has definitions. If left blank, results are returned from the first dictionary that has definitions. By default, dictionaries are searched in this order: ahd, wiktionary, webster, century, wordnet"
    define.flag [:p, :part], :default_value => nil, :arg_name => 'part', :desc => 'Comma-separated list of parts of speech. See http://developer.wordnik.com/docs.html#!/word/getDefinitions_get_2 for list of parts.'
    define.switch :increl, :default_value => false, :arg_name => 'increl', :desc => 'Return related words with definitions'
    define.switch :inctags, :default_value => false, :arg_name => 'inctags', :desc => 'Return a closed set of XML tags in response'
    define.action do |global_options,options,args|
      search = args[0]
      params = {defdict: options[:defdict], limit: options[:limit], increl: options[:increl], canon: options[:canon], inctags: options[:inctags]}
      df = Lyracyst::Wordnik::Define.new
      df.get_def(search, options[:p], params)
    end
  end
  nik.desc 'Fetch examples from Wordnik'
  nik.arg_name 'example'
  nik.command :example do |example|
    example.flag [:s, :skip], :default_value => 0, :arg_name => 'skip', :desc => 'Results to skip'
    example.switch :incdups, :default_value => false, :desc => 'Show duplicate examples from different sources'
    example.action do |global_options,options,args|
      search = args[0]
      params = {canon: options[:canon], incdups: options[:incdups], limit: options[:limit], skip: options[:s]}
      ex = Lyracyst::Wordnik::Example.new
      ex.get_ex(search, params)
    end
  end
  nik.desc 'Fetches related words from Wordnik'
  nik.arg_name 'relate'
  nik.command :relate do |relate|
    relate.flag [:relt], :default_value => nil, :arg_name => 'reltypes', :desc => 'Limits the total results per type of relationship type'
    relate.flag [:rell], :default_value => 10, :arg_name => 'rell', :desc => 'Restrict to the supplied relationship types'
    relate.action do |global_options,options,args|
      search = args[0]
      params = {canon: options[:canon], rellimit: options[:rell]}
      ex = Lyracyst::Wordnik::Relate.new
      ex.get_rel(search, params, options[:relt])
    end
  end
  nik.desc 'Fetches pronunciations from Wordnik'
  nik.arg_name 'pronounce'
  nik.command :pronounce do |pronounce|
    pronounce.flag [:src], :default_value => nil, :arg_name => 'source', :desc =>'Get from a single dictionary. Valid options: ahd, century, cmu, macmillan, wiktionary, webster, or wordnet'
    pronounce.flag [:pt], :default_value => nil, :arg_name => 'ptype', :desc => 'Text pronunciation type', :long_desc => 'ahd, arpabet, gcide-diacritical, IPA'
    pronounce.action do |global_options,options,args|
      search = args[0]
      params = {canon: options[:canon], limit: options[:limit], source: options[:src]}
      pr = Lyracyst::Wordnik::Pronounce.new
      pr.get_pro(search, params, options[:pt])
    end
  end
  nik.desc 'Fetches hyphenation and syllable stresses from Wordnik. Primary stress is red, secondary stress is bright white.'
  nik.arg_name 'hyphen'
  nik.command :hyphen do |hyphen|
    hyphen.flag :source, :default_value => nil, :arg_name => 'source', :desc => "Get from a single dictionary. Valid options: ahd, century, wiktionary, webster, and wordnet."
    hyphen.action do |global_options,options,args|
      search = args[0]
      params = {canon: options[:canon], limit: options[:limit]}
      if options[:source] != nil then params[:source] = options[:source]; end
      hyph = Lyracyst::Wordnik::Hyphen.new
      hyph.get_hyph(search, params)
    end
  end
  nik.desc 'Fetches bi-gram phrases from Wordnik'
  nik.arg_name 'phrase'
  nik.command :phrase do |phrase|
    phrase.flag [:wlmi], :default_value => 13, :arg_name => 'wlmi', :desc => 'Minimum WLMI(weighted mutual info) for the phrase.'
    phrase.action do |global_options,options,args|
      search = args[0]
      params = {canon: options[:canon], limit: options[:limit], wlmi: options[:wlmi]}
      phra = Lyracyst::Wordnik::Phrase.new
      phra.get_phr(search, params)
    end
  end
  nik.desc 'Fetches etymologies from Wordnik'
  nik.arg_name 'origin'
  nik.command :origin do |origin|
    origin.action do |global_options,options,args|
      search = args[0]
      params = {canon: options[:canon]}
      orig = Lyracyst::Wordnik::Origin.new
      orig.get_et(search, params)
    end
  end
end

desc 'Rhymebrain operations'
arg_name 'rhymebrain'
command :rbrain do |rb|
  rb.flag [:lang], :default_value => 'en', :arg_name => 'lang', :desc => 'ISO639-1 language code (optional). Eg. en, de, es, fr, ru'
  rb.flag [:max], :default_value => nil, :arg_name => 'max', :desc => '(optional) The number of results to return. If you do not include this parameter, RhymeBrain will choose how many words to show based on how many good sounding rhymes there are for the word.'
  rb.desc 'Fetches rhymes from Rhymebrain.com'
  rb.arg_name 'rhyme'
  rb.command :rhyme do |rhyme|
    rhyme.action do |global_options,options,args|
      search = args[0]
      params = {lang: options[:lang], max: options[:max]}
      rhym = Lyracyst::Rhymebrain::Rhyme.new
      rhym.get_rhyme(search, params)
    end
  end
  rb.desc 'Fetches word info from Rhymebrain.com'
  rb.arg_name 'info'
  rb.command :info do |info|
    info.action do |global_options,options,args|
      search = args[0]
      params = {lang: options[:lang], max: options[:max]}
      info = Lyracyst::Rhymebrain::Info.new
      info.get_info(search, params)
    end
  end
  rb.desc 'Fetches combined words (portmanteaus) from Rhymebrain.com'
  rb.arg_name 'combine'
  rb.command :combine do |combine|
    combine.action do |global_options,options,args|
      search = args[0]
      params = {lang: options[:lang], max: options[:max]}
      port = Lyracyst::Rhymebrain::Combine.new
      port.get_port(search, params)
    end
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
