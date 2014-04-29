# coding: utf-8
require 'httpi'
require 'multi_json'
require 'multi_xml'

module Lyracyst
  # The Relate class defines methods for interacting with the
  # Altervista API.
  class Relate
    # Altervista.org's thesaurus service provides related words.
    # The service limits each API key to 5000 queries a day. If
    # maximum number of queries has been reached, this method
    # will exit. Search language can be it_IT, fr_FR, de_DE,
    # en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU,
    # sk_SK. This method calls {Related#update} and {Related#submit}.
    #
    # @param search [String] The word or phrase to search for.
    # @param result [Array] The JSON response.
    # @param lang [String] Search language code.
    # @param fmt [String] Results format, json or xml.
    def relate(search, result, lang, fmt)
      max = 5000
      t = Time.now
      y = t.year.to_s
      m = t.month
      d = t.day
      if m < 10 then m = "0#{m}" else  m = m.to_s; end
      if d < 10 then d = "0#{d}" else d = d.to_s; end
      date = "#{y}#{m}#{d}"
      dateint = date.to_i
      if File.exist?('json/synqc.json') == true
        rl = File.readlines('json/synqc.json')
        rl = rl[0]
        loadrl = MultiJson.load(rl)
        testdate = loadrl['date']
        querycount = loadrl['querycount']
        pdateint = testdate.to_i
        if dateint > pdateint == true
          re = Lyracyst::Relate.new
          #re.update(dateint, querycount)
        end
      else
        querycount = 0
        new = { 'date' => dateint, 'querycount' => querycount }
        #fo = File.open('json/synqc.json', "w+") # FIXME json dir operations fail in Cucumber
        #tofile = MultiJson.dump(new)
        #fo.print tofile
        #fo.close
      end
      if querycount < max
        urlprefix = 'http://thesaurus.altervista.org/thesaurus/v1'
        apikey = ENV['THESAURUS']
        url = "#{urlprefix}?key=#{apikey}&word=#{search}&language=#{lang}&output=#{fmt}"
        re = Lyracyst::Relate.new
        re.submit(url, dateint, result, querycount)
      else
        puts 'Max queries per day for related words has been reached.'
      end
    end
    # Opens URL and returns response. HTTPI supports multiple HTTP
    # clients, and selects the 'best' in the following order:
    # httpclient, curb, em_http, excon, net_http, net_http_persistent.
    # For C extensions, curb is recommended. For pure Ruby, use excon.
    # You can specify a client to use like this:
    # request = HTTPI::Request.new(url)
    # HTTPI.get(request, :curb)
    #
    # @param url [String] The query URL
    # @param result [Array] The response
    # @param rtype [String] Results format, json or xml.
    def http(url, result, rtype)
      request = HTTPI::Request.new(url)
      HTTPI.log = false
      request = HTTPI.get(request)
      if request.code == 200
        if request.headers['Content-Type'] =~ /json/
          rtype = 'json'
          result = request.body
        elsif request.headers['Content-Type'] =~ /xml/
          rtype = 'xml'
          result = request.body
        else
          puts "HTTP Content Type #{request.headers['Content-Type']}"
        end
      else
        puts "HTTP Status #{request.code}"
        puts "HTTP Body #{request.body}"
      end
      return result, rtype
    end
    # Parses a JSON response into a Ruby object. multi_json supports
    # multiple JSON parsers, and selects the 'best' in the following order:
    # oj, yajl, json, json_pure, okjson. For C extensions, oj is recommended.
    # For pure Ruby, use json_pure. This method calls {Related#extract}.
    #
    # @param result [String] The response body.
    def pjson(result)
      resulta = MultiJson.load(result)
      resulta = resulta['response']
      re = Lyracyst::Relate.new
      re.extract(resulta)
    end
    # Parses a XML response into a Ruby object. multi_xml supports
    # multiple XML parsers, and selects the 'best' in the following order:
    # ox, libxml, nokogiri, rexml. For C extensions, ox is recommended. For
    # pure Ruby, use REXML. This method calls {Related#extract}.
    #
    # @param result [String] The response body.
    def pxml(result)
      resulta = MultiXml.parse(result)
      resulta = resulta['response']
      re = Lyracyst::Relate.new
      re.extract(resulta)
    end
    # Extracts related words from the response and prints them.
    #
    # @param resulta [Array] An array of values from the response.
    def extract(resulta)
      x = 0
      y = resulta.length - 1
      while x <= y
        item=resulta[x]
        item=item['list']
        puts "Related words: #{item['category'].gsub(/\(|\)/, '')} - #{item['synonyms']}"
        x += 1
      end
    end
    # Submits search term and parameters to Altervista.
    # This method calls {Related#http}, {Related#pjson},
    # {Related#pxml} and {Related#update}.
    #
    # @param url [String] The assembled search URL.
    # @param dateint [Fixnum] Today's date.
    # @param result [String] The JSON response.
    # @param querycount [Fixnum] Number of queries today.
    def submit(url, dateint, result, querycount)
      #if ENVIRONMENT == 'javascript'
        #url = "#{url}&callback=synonymSearch"
      #end
      re = Lyracyst::Relate.new
      rtype = ''
      result = re.http(url, result, rtype)
      rtype = result[1]
      result = result[0]
      if rtype == 'json'
        re.pjson(result)
      elsif rtype == 'xml'
        re.pxml(result)
      else
        puts "Invalid data format."
      end
      querycount += 1
      #re.update(dateint, querycount)
    end
    # Sets today's date and writes it with querycount to syncqc.json.
    #
    # @param dateint [Fixnum] Today's date in integer form.
    # @param querycount [Fixnum] Number of daily queries in integer form.
    def update(dateint, querycount)
      qct = { 'date' => dateint, 'querycount' => querycount }
      if File.exist?('json/synqc.json') == true
        fo = File.open('json/synqc.json', "w+")
      else
        fo = File.new('json/synqc.json', "w+")
      end
      tofile = MultiJson.dump(qct)
      fo.print tofile
      fo.close
    end
  end
end
