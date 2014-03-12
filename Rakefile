# -*- encoding: utf-8 -*-
# Query parameters are preceded by a question mark ("?") and separated by ampersands ("&") and consist of the parameter name,
# an equals sign ("="), and a value.
# Each application can perform upto 5000 queries per day.

desc "Search thesaurus.altervista.com for synonyms"
task :syn => :environment do
  require 'multi_json'
  require 'nokogiri'
  require 'open-uri/cached'
  OpenURI::Cache.cache_path = 'tmp/open-uri' #transparent caching
  print 'Opening data URI...'
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
    searchword='test' # (urlencoded string)
    searchlang='en_US' # it_IT, fr_FR, de_DE, en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU, sk_SK
    dataoutput='json' # xml or json (default xml)
    data="#{uriprefix}?key=#{apikey}&word=#{searchword}&language=#{searchlang}&output=#{dataoutput}"
    if environment == 'javascript' # (requires output=json)
      data="#{data}&callback=synonymSearch"
    end
    uri=open(data).read #submit search query
    dataload=MultiJson.load(uri) #parse it
    q=MultiJson.dump(dataload, :pretty => true) #reencode pretty json
    fo=File.open("json/query.json", "w+")
    fo.print q
    fo.close
    querycount+=1 #increment daily queries
    fo=File.open("json/qc.json", "w+")
    qct={'date' => date, 'querycount' => querycount}
    tofile=MultiJson.dump(qct)
    fo.print tofile
    fo.close
  else
    puts "Max queries per day has been reached, exiting."
  end
  puts 'done.'
end

desc "Inject entries into ActiveRecord"
task :inj => :environment do
  require 'multi_json'
  print 'Adding products to database'
  fa=[]
  Dir.glob('json/*.json').select {|f| fa.push f}
  pa={}; x=0; y=fa.length; y-=1; #declarations
  fa.sort
  while x <= y
    file=File.readlines(fa[x])
    pa=JSON.parse(file.join)
    ptitle=pa['title']
    pcapabilities=pa['capabilities']
    if pcapabilities.class == Array then pcapabilities=pcapabilities.join(", "); end
    pdeveloper=pa['developer']
    pformats=pa['formats']
    if pformats.class == Array then pformats=pformats.join(", "); end
    plink=pa['link']
    pplatform=pa['platform']
    if pplatform.class == Array then pplatform=pplatform.join(", "); end
    prlink=pa['productlink']
    if prlink.class == Array then prlink=prlink.join(", "); end
    psummary=pa['summary']
    ptaglist=pa['taglist']
    ptaglist=ptaglist.join(", ")
    Product.create! :title=>ptitle, :capabilities=>pcapabilities, :developer=>pdeveloper, :formats=>pformats, :link=>plink, :platform=>pplatform, :productlink=>prlink, :summary=>psummary, :taglist=>ptaglist
    print '.'
    x+=1
  end
  puts 'done.'
end

desc "Get rhymes from arpabet.heroku.com"
task :rhy => :environment do
  require 'multi_json'
  require 'open-uri/cached'
  delimited=false; full=false; limit=0; param=false; searchword='test'; skip=0; #declarations
  OpenURI::Cache.cache_path = 'tmp/open-uri' #transparent caching
  data="http://arpabet.heroku.com/words/#{searchword}"
  if full == true then param=true; end
  if delimited == true then param=true; end
  if limit > 0 then param=true; end
  if skip > 0 then param=true; end
  if param == true
    data << "?"
    if full == true then data << "full=1&" end
    if delimited == true then data << "delimited=1&"; end
    if limit > 0 then data << "limit=#{limit}&"; end
    if skip > 0 then data << "skip=#{skip}&"
  end
  uri=open(data).read #submit search query
  if uri.class == string
    #handle semicolon-delimited string
  else
    #treat as array of strings or array of hashes
  end
end
