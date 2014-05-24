#!/usr/bin/env ruby
# coding: utf-8
require 'gli'
require 'lyracyst/rhymebrain'
require 'lyracyst/version'
require 'lyracyst/wordnik'

include GLI::App
program_desc 'A powerful word search tool that fetches definitions, related words, rhymes, and much more. Rhymes are provided by rhymebrain.com.'
config_file '.lyracyst.yml'
version Lyracyst::VERSION

desc 'HTTP adapter'
long_desc 'httpclient, curb, em_http, net_http_persistent, excon, rack'
default_value :excon
arg_name 'http'
flag [:h,:http]

desc 'JSON adapter'
long_desc 'oj, yajl, json_gem, json_pure'
default_value :json_pure
arg_name 'json'
flag [:j,:json]

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
    df = Lyracyst::Wordnik.new
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
    ex = Lyracyst::Wordnik.new
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
    ex = Lyracyst::Wordnik.new
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
    pr = Lyracyst::Wordnik.new
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
    hyph = Lyracyst::Wordnik.new
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
    phra = Lyracyst::Wordnik.new
    phra.get_phr(search, params)
  end
end

desc 'Fetches etymologies from Wordnik'
arg_name 'word'
command :origin do |c|
  c.action do |global_options,options,args|
    search = args[0]
    params = {canon: false}
    orig = Lyracyst::Wordnik.new
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
    rhym = Lyracyst::Rhymebrain.new
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
    info = Lyracyst::Rhymebrain.new
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
    port = Lyracyst::Rhymebrain.new
    port.get_port(search, params)
  end
end

pre do |global,command,options,args|
  # Pre logic here
  # Return true to proceed; false to abort and not call the
  # chosen command
  # Use skips_pre before a command to skip this block
  # on that command only
  wn = Lyracyst::Wordnik.new
  http = global[:h]
  json = global[:j]
  xml = global[:x]
  if http.class != Symbol then http = http.to_sym; end
  wn.set_http(http)
  if json.class != Symbol then json = json.to_sym; end
  wn.set_json(json)
  if xml.class != Symbol then xml = xml.to_sym; end
  wn.set_xml(xml)
  label = 'Global options'
  wn.label(label)
  print "➜#{global}➜"
  label = 'Command'
  wn.label(label)
  print "➜#{command.name}➜"
  label = 'Command options'
  wn.label(label)
  print "➜#{options}➜"
  label = 'Args'
  wn.label(label)
  print "➜#{args}➜"
  label =  'Bootstrapped'
  wn.label(label)
  puts ''
  true
end

post do |global,command,options,args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
  wn = Lyracyst::Wordnik.new
  label =  'Shutdown'
  wn.label(label)
  puts ''
end

on_error do |exception|
  # Error logic here
  # return false to skip default error handling
  true
end

exit run(ARGV)
