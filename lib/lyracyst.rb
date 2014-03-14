#!~/.rvm/rubies/default/bin/ruby
# Query parameters are preceded by a question mark ("?") and separated by ampersands ("&") and consist of the parameter name,
# an equals sign ("="), and a value.
# Each thesaurus.altervista.org application can perform upto 5000 queries per day.

require 'multi_json'
require 'nokogiri'
require 'open-uri/cached'
require 'wordnik'
OpenURI::Cache.cache_path = 'tmp/open-uri' #transparent caching
environment='ruby'
result=''
search='weather' # (urlencoded string)
uri=''
class Fetch
  def search(url, result)
    result=open(url).read #submit search query
  end
end
class Search
  def syn(search)
    environment='ruby'; maxqueries=5000; querycount=0; t=Time.now; y=t.year.to_s; m=t.month; d=t.day; #declarations
    if m < 10 then m="0#{m}" else  m=m.to_s; end #2-digits
    if d < 10 then d="0#{d}" else d=d.to_s; end
    date="#{y}#{m}#{d}"
    dateint=date.to_i
    #pd=Date.parse(date)
    if FileTest.exist?("json/qc.json") == true
      rl=File.readlines("json/qc.json")
      rl=rl[0]
      loadrl=MultiJson.load(rl)
      testdate=loadrl['date']
      testcount=loadrl['querycount']
      pdateint=testdate.to_i
      if dateint > pdateint == true #track date changes
        qct={'date' => date, 'querycount' => querycount}
        fo=File.open("json/qc.json", "w+")
        tofile=MultiJson.dump(qct)
        fo.print tofile
        fo.close
      end
    end
    if testcount < maxqueries #make sure we don't abuse the service
      uriprefix='http://thesaurus.altervista.org/thesaurus/v1'
      apikey=File.readlines('keys/thesaurus.key') #search API key, get one at http://thesaurus.altervista.org/mykey
      apikey=apikey[0].chomp
      searchlang='en_US' # it_IT, fr_FR, de_DE, en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU, sk_SK
      dataoutput='json' # xml or json (default xml)
      url="#{uriprefix}?key=#{apikey}&word=#{search}&language=#{searchlang}&output=#{dataoutput}"
      if environment == 'javascript' # (requires output=json)
        data="#{url}&callback=synonymSearch"
      end
      f=Fetch.new()
      result=f.search(url, result) #submit search query
      dataload=MultiJson.load(result) #parse it
      q=MultiJson.dump(dataload, :pretty => true) #reencode pretty json
      fo=File.open("json/synquery.json", "w+")
      fo.print q
      fo.close
      querycount+=1 #increment daily queries
      fo=File.open("json/synqc.json", "w+")
      qct={'date' => date, 'querycount' => querycount}
      tofile=MultiJson.dump(qct)
      fo.print tofile
      fo.close
    else
      puts "Max queries per day has been reached, exiting."
    end
  end
  def nik(search)
    apikey=File.readlines('keys/wordnik.key') #search API key, get one at http://thesaurus.altervista.org/mykey
    apikey=apikey[0]
    apikey=apikey.chomp
    Wordnik.configure do |cfg| #FIXME
      cfg.api_key=apikey
      cfg.response_format='json'
      cfg.logger = Logger.new(STDOUT) #defaults to Rails.logger or Logger.new(STDOUT). Set to Logger.new('/dev/null') to disable logging.
    end
    define=wn.word.get_definitions(search)
    puts define
  end
  def rhy(search)
    url="http://arpabet.heroku.com/words/#{search}"
    f=Fetch.new()
    result=f.search(url, result) #submit search query
    parse=MultiJson.load(result)
    print "#{search} rhymes with: "
    x=0
    y=parse.length - 1
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

