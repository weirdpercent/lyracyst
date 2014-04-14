#!/usr/bin/env ruby

# The program takes a search term and returns a list.
# The list can be either definitions, related words,
# rhymes, or all three at once.
#
# Author::    Drew Prentice  (mailto:weirdpercent@gmail.com)
# Copyright:: Copyright (c) 2014 Drew Prentice
# License::   MIT
require 'rubygems'
require 'commander/import'
#require 'configatron'
require 'multi_json'
#require 'nokogiri'
require 'open-uri/cached'
require 'wordnik'
OpenURI::Cache.cache_path = 'tmp/open-uri'
environment='ruby'
result=''

# Handles tasks related to fetching queries
class Fetch

  # Opens URL and returns the JSON response.
  #
  # @param url [String] The query URL
  # @param result [String] The JSON response.
  def search(url, result)
    result=open(url).read
  end

  # Sets today's date and writes it with querycount to syncqc.json.
  #
  # @param dateint [Fixnum] Today's date in integer form.
  # @param querycount [Fixnum] Number of daily queries in integer form.
  def update(dateint, querycount)
    qct={'date' => dateint, 'querycount' => querycount}
    fo=File.open("json/synqc.json", "w+")
    tofile=MultiJson.dump(qct)
    fo.print tofile
    fo.close
  end

  # Extracts related words from JSON response and prints them.
  #
  # @param x [Fixnum] Integer always set to zero.
  # @param y [Fixnum] Number of items in resulta Array minus 1.
  # @param resulta [Array] An array of values from JSON response.
  def rel(x, y, resulta)
    while x <= y
      resultl=resulta[x]
      list=resultl['list']
      cat=list['category'].gsub(/\(|\)/, '')
      puts "Related words: #{list['category']} - #{list['synonyms']}"
      x+=1
    end
  end

  # Submits search term and parameters to Altervista.
  # searchlang can be de_DE, el_GR, en_US, es_ES, fr_FR,
  # it_IT, no_NO, pt_PT, ro_RO, ru_RU, or sk_SK.
  # dataoutput only takes 'json' right now. This method calls
  # {Fetch#search} and {Fetch#update}.
  #
  # @param search [String] The word or phrase to search for.
  # @param dateint [Fixnum] Today's date in integer form.
  # @param result [String] The JSON response.
  # @param environment [String] Execution environment, right now just ruby.
  # @param querycount [Fixnum] Number of daily queries in integer form.
  def submit(search, dateint, result, environment, querycount)
    urlprefix='http://thesaurus.altervista.org/thesaurus/v1'
    apikey=ENV['THESAURUS']
    searchlang='en_US'
    dataoutput='json'
    url="#{urlprefix}?key=#{apikey}&word=#{search}&language=#{searchlang}&output=#{dataoutput}"
    if environment == 'javascript'
      url="#{url}&callback=synonymSearch"
    end
    f=Fetch.new()
    resultj=f.search(url, result)
    resultp=MultiJson.load(resultj)
    resulta=resultp['response']
    x=0
    y=resulta.length-1
    f.rel(x, y, resulta)
    querycount+=1
    f.update(dateint, querycount)
  end

  # Formats rhyme results, assumes a space means a
  # word contraction, i.e. raison d'etre and inserts
  # an apostrophe. Also removes Arpabet numbers.
  #
  # @param x [Fixnum] Integer always set to zero.
  # @param y [Fixnum] Number of items in resulta Array minus 1.
  # @param parse [String] The rhyming word to be formatted.
  def parse(x, y, parse)
    while x <= y
      if parse[x] =~ / \d/
        fix=parse[x]
        parse[x]=fix.gsub(/ \d/ , "")
      end
      if parse[x] =~ / /
        fix=parse[x]
        parse[x]=fix.gsub(' ', "'")
      end
      print "#{parse[x]} "
      x+=1
    end
  end
end

# The Search class defines three methods for submitting queries.
class Search
  # Altervista.org's thesaurus service provides related words.
  # The service limits each API key to 5000 queries a day. If
  # maximum number of queries has been reached, this methods
  # will exit. This method calls {Fetch#update} and {Fetch#submit}.
  #
  # @param search [String] The word or phrase to search for.
  # @param result [String] The JSON response.
  def related(search, result)
    environment='ruby'; maxqueries=5000; querycount=0; t=Time.now; y=t.year.to_s; m=t.month; d=t.day;
    if m < 10 then m="0#{m}" else  m=m.to_s; end
    if d < 10 then d="0#{d}" else d=d.to_s; end
    date="#{y}#{m}#{d}"
    dateint=date.to_i
    if File.exist?("json/synqc.json") == true
      rl=File.readlines("json/synqc.json")
      rl=rl[0]
      loadrl=MultiJson.load(rl)
      testdate=loadrl['date']
      testcount=loadrl['querycount']
      pdateint=testdate.to_i
      if dateint > pdateint == true
        f=Fetch.new()
        f.update(dateint, querycount)
      end
    else
      testcount=0
    end
    if testcount < maxqueries
      f=Fetch.new()
      f.submit(search, dateint, result, environment, querycount)
    else
      puts "Max queries per day has been reached."
    end
  end
  # Wordnik.com's service provides definitions. The logger
  # defaults to Rails.logger or Logger.new(STDOUT). Set to
  # Logger.new('/dev/null') to disable logging.
  #
  # @param search [String] The word or phrase to search for.
  def define(search)
    apikey=ENV['WORDNIK']
    Wordnik.configure do |cfg|
      cfg.api_key=apikey
      cfg.response_format='json'
      cfg.logger = Logger.new('/dev/null')
    end
    define=Wordnik.word.get_definitions(search)
    define.map { |defi|
      text=defi['text']; att=defi['attributionText']; part=defi['partOfSpeech'];
      puts "Definition: #{part} - #{text}"
      #puts "Definition: #{part} - #{text} - #{att}" #With attribution to source
    }
  end

  # ARPA created ARPABET decades ago to find words that
  # rhyme. The technology is still quite relevant today.
  # This program uses the Heroku app based on ARPABET.
  #
  # @param search [String] The word or phrase to search for.
  def rhyme(search)
    url="http://arpabet.heroku.com/words/#{search}"
    f=Fetch.new()
    result=f.search(url, result) #submit search query
    parse=MultiJson.load(result)
    print "Rhymes with: "
    x=0
    y=parse.length - 1
    f.parse(x, y, parse)
    print "\n"
  end
end

program :name, 'lyracyst'
program :version, '0.0.5'
program :description, 'A powerful word search tool that fetches definitions, related words, and rhymes.'
command :get do |c|
  c.syntax = 'lyracyst get [options]'
  c.summary = 'Fetches all sources'
  c.description = 'Searches definitions, related words, and rhymes for a given query'
  c.example 'Searches definitions, related words, and rhymes for a given query', 'lyracyst get test'
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.define(search)
    s.related(search, result)
    s.rhyme(search)
  end
end

command :define do |c|
  c.syntax = 'lyracyst define [options]'
  c.summary = 'Fetches definitions'
  c.description = 'Uses the Wordnik API to get definitions'
  c.example 'Uses the Wordnik API to get definitions', 'lyracyst define test'
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.define(search)
  end
end

command :related do |c|
  c.syntax = 'lyracyst related [options]'
  c.summary = 'Fetches related words'
  c.description = 'Uses the Altervista API to get related words'
  c.example 'Uses the Altervista API to get related words', 'lyracyst related test'
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.related(search)
  end
end

command :rhyme do |c|
  c.syntax = 'lyracyst rhyme [options]'
  c.summary = 'Fetches rhymes'
  c.description = 'Uses the ARPABET system to get rhymes'
  c.example 'Uses the ARPABET system to get rhymes', 'lyracyst rhyme test'
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.rhyme(search)
  end
end
