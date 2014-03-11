desc "Add product entries to database"
task :addjson => :environment do
  require 'multi_json'
  print 'Adding products to database'
  fa=[]
  Dir.glob('json/*.json').select {|f| fa.push f}
  pa={}
  x=0
  y=fa.length
  y-=1
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
