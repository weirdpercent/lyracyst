# Query parameters are preceded by a question mark ("?") and separated by ampersands ("&") and consist of the parameter name,
# an equals sign ("="), and a value.
# Each application can perform upto 5000 queries per day.

desc "Open data URI"
task :open => :environment do
  require 'multi_json'
  require 'nokogiri'
  require 'open-uri/cached'
  OpenURI::Cache.cache_path = '/tmp/open-uri'
  print 'Opening data URI...'
  environment='ruby'
  maxqueries=5000
  querycount=0
  t=Time.now
  y=t.year.to_s
  m=t.month
  d=t.day
  if m < 10
    m="0#{m}"
  else
    m=m.to_s
  end
  if d < 10
    d="0#{d}"
  else
    d=d.to_s
  end
  date="#{y}#{m}#{d}"
  dateint=date.to_i
  #pd=Date.parse(date)
  qct={}
  if FileTest.exist?("qc.json") == true
    rl=File.readlines("qc.json")
    rl=rl[0]
    loadrl=MultiJson.load(rl)
    testdate=loadrl['date']
    testcount=loadrl['querycount']
    pdateint=testdate.to_i
    if dateint > pdateint == true
      qct['date']=date
      qct['querycount']=querycount
      fo=File.open("qc.json", "w+")
      tofile=MultiJson.dump(qct)
      fo.print tofile
      fo.close
    end
  end
  if testcount < 5000
    #do the search
  else
    puts "Max queries per day has been reached, exiting."
  end
  uriprefix='http://thesaurus.altervista.org/thesaurus/v1'
  apikey=File.readlines('thesaurus.key') #search API key, get one at http://thesaurus.altervista.org/mykey
  searchword='' # (urlencoded string)
  searchlang='en_US' # it_IT, fr_FR, de_DE, en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU, sk_SK
  dataoutput='json' # xml or json (default xml)
  #callback # javascript only (requires output=json)
  data="#{uriprefix}/?key=#{apikey}&word=#{searchword}&language=#{searchlang}&output=#{dataoutput}"
  #if environment == 'javascript' # (requires output=json)
    #data="#{data}&callback=synonymSearch"
  #end
  uri=open(data)
  puts 'done.'
end
