#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
#require 'configatron'
require 'multi_json'
#require 'nokogiri'
require 'open-uri/cached'
require 'wordnik'
require 'commander.rb'
OpenURI::Cache.cache_path = 'tmp/open-uri' #transparent caching
environment='ruby'
result=''
#search='test' # (urlencoded string)
#print "Enter a word: " #change commenting here to convert between command line and test modes
class Fetch
  def search(url, result)
    result=open(url).read #submit search query
  end
  def update(dateint, querycount)
    qct={'date' => dateint, 'querycount' => querycount}
    fo=File.open("json/synqc.json", "w+")
    tofile=MultiJson.dump(qct)
    fo.print tofile
    fo.close
  end
  def rel(x, y, resulta)
    while x <= y
      resultl=resulta[x]
      list=resultl['list']
      cat=list['category'].gsub(/\(|\)/, '')
      puts "Related words: #{list['category']} - #{list['synonyms']}"
      x+=1
    end
  end
  def submit(search, dateint, result, environment, querycount)
    urlprefix='http://thesaurus.altervista.org/thesaurus/v1'
    #apikey=File.readlines('keys/thesaurus.key') #search API key, get one at http://thesaurus.altervista.org/mykey
    #apikey=apikey[0].chomp
    apikey=ENV['THESAURUS'] #access thru ENV vars for safe Travis builds
    searchlang='en_US' # it_IT, fr_FR, de_DE, en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU, sk_SK
    dataoutput='json' # xml or json (default xml)
    url="#{urlprefix}?key=#{apikey}&word=#{search}&language=#{searchlang}&output=#{dataoutput}"
    if environment == 'javascript' # (requires output=json)
      url="#{url}&callback=synonymSearch"
    end
    f=Fetch.new()
    resultj=f.search(url, result) #submit search query
    resultp=MultiJson.load(resultj)
    resulta=resultp['response']
    x=0
    y=resulta.length-1
    f.rel(x, y, resulta)
    querycount+=1 #increment daily queries
    f.update(dateint, querycount)
  end
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
class Search
  def related(search, result) # Each thesaurus.altervista.org application can perform upto 5000 queries per day.
    environment='ruby'; maxqueries=5000; querycount=0; t=Time.now; y=t.year.to_s; m=t.month; d=t.day; #declarations
    if m < 10 then m="0#{m}" else  m=m.to_s; end #2-digits #FIXME < not valid?
    if d < 10 then d="0#{d}" else d=d.to_s; end
    date="#{y}#{m}#{d}"
    dateint=date.to_i
    #pd=Date.parse(date)
    if File.exist?("json/synqc.json") == true
      rl=File.readlines("json/synqc.json")
      rl=rl[0]
      loadrl=MultiJson.load(rl)
      testdate=loadrl['date']
      testcount=loadrl['querycount']
      pdateint=testdate.to_i
      if dateint > pdateint == true #track date changes
        f=Fetch.new()
        f.update(dateint, querycount)
      end
    else
      testcount=0
    end
    if testcount < maxqueries #make sure we don't abuse the service
      f=Fetch.new()
      f.submit(search, dateint, result, environment, querycount)
    else
      puts "Max queries per day has been reached."
    end
  end
  def define(search)
    #apikey=File.readlines('keys/wordnik.key') #search API key, get one at http://developer.wordnik.com/
    #apikey=apikey[0].chomp
    apikey=ENV['WORDNIK'] #access thru ENV vars for safe Travis builds
    Wordnik.configure do |cfg|
      cfg.api_key=apikey
      cfg.response_format='json'
      cfg.logger = Logger.new('/dev/null') #defaults to Rails.logger or Logger.new(STDOUT). Set to Logger.new('/dev/null') to disable logging.
    end
    define=Wordnik.word.get_definitions(search)
    define.map { |defi|
      text=defi['text']; att=defi['attributionText']; part=defi['partOfSpeech'];
      puts "Definition: #{part} - #{text}"
      #puts "Definition: #{part} - #{text} - #{att}" #With attribution to source
    }
  end
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
program :version, '0.0.1'
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
  #c.option '--some-switch', 'Some switch that does something' # it_IT, fr_FR, de_DE, en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU, sk_SK
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
