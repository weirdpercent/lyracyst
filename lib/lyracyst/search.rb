# -*- encoding: utf-8 -*-
#!/usr/bin/env ruby
# require 'configatron'
require 'multi_json'
require 'wordnik'

module Lyracyst
  # Defines three methods for submitting queries.
  class Search
    # Altervista.org's thesaurus service provides related words.
    # The service limits each API key to 5000 queries a day. If
    # maximum number of queries has been reached, this methods
    # will exit. Search language can be it_IT, fr_FR, de_DE,
    # en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU,
    # sk_SK. This method calls {Fetch#update} and {Fetch#submit}.
    #
    # @param search [String] The word or phrase to search for.
    # @param result [Array] The JSON response.
    # @param lang [String] Search language code.
    # @param fmt [String] json or xml, currently just json.
    def related(search, result, lang, fmt)
      environment = 'ruby'
      maxqueries = 5000
      querycount = 0
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
        testcount = loadrl['querycount']
        pdateint = testdate.to_i
        if dateint > pdateint == true
          f = Lyracyst::Fetch.new
          f.update(dateint, querycount)
        end
      else
        testcount = 0
      end
      if testcount < maxqueries
        f = Lyracyst::Fetch.new
        f.submit(search, dateint, result, querycount, lang, fmt)
      else
        puts 'Max queries per day has been reached.'
      end
    end
    # Wordnik.com's service provides definitions. The logger
    # defaults to Rails.logger or Logger.new(STDOUT). Set to
    # Logger.new('/dev/null') to disable logging.
    #
    # @param search [String] The word or phrase to search for.
    def define(search)
      apikey = ENV['WORDNIK']
      Wordnik.configure do |cfg|
        cfg.api_key = apikey
        cfg.response_format = 'json'
        cfg.logger = Logger.new('/dev/null')
      end
      define = Wordnik.word.get_definitions(search)
      if define != ''
        define.map { |defi|
          text = defi['text']
          # att = defi['attributionText']
          part = defi['partOfSpeech']
          puts "Definition: #{part} - #{text}"
          # puts "Definition: #{part} - #{text} - #{att}" #With attribution
        }
      else
        puts 'Wordnik returned an empty string.'
      end
    end
    # ARPA created ARPABET decades ago to find words that
    # rhyme. The technology is still quite relevant today.
    # This program uses the Heroku app based on ARPABET.
    # This method calls {Fetch#search}.
    #
    # @param search [String] The word or phrase to search for.
    def rhyme(search, result)
      url = "http://arpabet.heroku.com/words/#{search}"
      f = Lyracyst::Fetch.new
      result = f.search(url, result)
      puts "Rhymes with: #{result}"
    end
  end
end
