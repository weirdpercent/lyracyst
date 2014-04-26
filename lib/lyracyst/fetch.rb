# -*- encoding: utf-8 -*-
#!/usr/bin/env ruby
# require 'configatron'
require 'multi_json'
require 'open-uri/cached'

module Lyracyst
# Handles tasks related to fetching queries
  class Fetch
    # Opens URL and returns the JSON response.
    #
    # @param url [String] The query URL
    # @param result [String] The JSON response.
    def search(url, result)
      OpenURI::Cache.cache_path = 'tmp/open-uri'
      uri = URI.parse(url)
      status = uri.open.meta[:status]
      if status[0] == '200'
        result = uri.open.read
        return result
      else
        puts "HTTP Status #{status[0]} #{status[1]}"
      end
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
    # Extracts related words from JSON response and prints them.
    #
    # @param x [Fixnum] Integer always set to zero.
    # @param y [Fixnum] Number of items in resulta Array minus 1.
    # @param resulta [Array] An array of values from JSON response.
    def rel(x, y, resulta)
      while x <= y
        resultl = resulta[x]
        list = resultl['list']
        puts "Related words: #{list['category'].gsub(/\(|\)/, '')} - #{list['synonyms']}"
        x += 1
      end
    end
    # Submits search term and parameters to Altervista.
    # lang can be de_DE, el_GR, en_US, es_ES, fr_FR,
    # it_IT, no_NO, pt_PT, ro_RO, ru_RU, or sk_SK.
    # fmt only takes 'json' right now. This method calls
    # {Fetch#search}, {Fetch#rel} and {Fetch#update}.
    #
    # @param search [String] The word or phrase to search for.
    # @param dateint [Fixnum] Today's date.
    # @param result [String] The JSON response.
    # @param querycount [Fixnum] Number of queries today.
    # @param lang [String] Search language code
    # @param fmt [String] json or xml, currently just json.
    def submit(search, dateint, result, querycount, lang, fmt)
      urlprefix = 'http://thesaurus.altervista.org/thesaurus/v1'
      apikey = ENV['THESAURUS']
      url = "#{urlprefix}?key=#{apikey}&word=#{search}&language=#{lang}&output=#{fmt}"
      #if environment == 'javascript'
        #url = "#{url}&callback=synonymSearch"
      #end
      f = Lyracyst::Fetch.new
      resultj = f.search(url, result)
      resultp = MultiJson.load(resultj)
      resulta = resultp['response']
      x = 0
      y = resulta.length - 1
      f.rel(x, y, resulta)
      querycount += 1
      #f.update(dateint, querycount) # FIXME Won't run in Aruba/Cucumber
    end
  end
end
