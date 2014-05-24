# coding: utf-8
#%w(curb em-synchrony em-http eventmachine excon httpclient httpi net/http/persistent rainbow).map {|lib| require lib}
#%w(json/ext json/pure multi_json oj yajl).map {|lib| require lib}
#%w(libxml multi_xml ox rexml/document).map {|lib| require lib}
%w{httpi multi_json multi_xml rainbow}.map {|lib| require lib}

module Lyracyst

  # Wordnik.com's service provides definitions, examples,
  # related words, pronunciations, hyphenation, phrases,
  # and etymologies.
  class Wordnik
    HTTPI.log = false

    # Optionally sets HTTP adapter with httpi. Supports [:httpclient,
    # :curb, :em_http, :net_http_persistent, :excon, :rack]
    #
    # @param http [Symbol] The http adapter to use. Smart defaults.
    def set_http(http)
      HTTPI.adapter = http
    end

    # Optionally sets JSON adapter with multi_json. Supports [:oj,
    # :yajl, :json_gem, :json_pure]
    #
    # @param mj [Symbol] The JSON adapter to use. Smart defaults.
    def set_json(mj)
      MultiJson.use(mj)
    end

    # Optionally sets XML adapter with multi_json. Supports [:ox,
    # :libxml, :nokogiri, :rexml]
    #
    # @param mx [Symbol] The XML adapter to use. Smart defaults.
    def set_xml(mx)
      MultiXml.parser = mx
    end

    # Prints colored element label.
    #
    # @param label [String] The label to print
    def label(label)
      print Rainbow("[").blue.bright
      print Rainbow(label).green.bright
      print Rainbow("] ").blue.bright
    end

    # Fetches dynamically generated URL. Functions are definitions,
    # examples, relatedWords, pronunciations, hyphenation, phrases,
    # and etymologies.
    #
    # @param search [String] The word or phrase to search for.
    # @param func [String] The search function to use.
    # @param params [Hash] The search parameters to use.
    # @param result [String] The search response.
    def get_word(search, func, params, result)
      prefix = 'http://api.wordnik.com:80/v4/word.json/'
      word, pcont = "#{prefix}#{search}/#{func}?", []
      params.map { |k,v|
        if k == :canon then pcont.push "useCanonical=#{v}&"; end
        if k == :incdups then pcont.push "includeDuplicates=#{v}&"; end
        if k == :increl then pcont.push "includeRelated=#{v}&"; end
        if k == :inctags then pcont.push "includeTags=#{v}&"; end
        if k == :limit then pcont.push "limit=#{v}&"; end
        if k == :part then pcont.push "partOfSpeech=#{v}&"; end
        if k == :rellimit then pcont.push "limitPerRelationshipType=#{v}&"; end
        if k == :reltypes then pcont.push "relationshipTypes=#{v}&"; end
        if k == :skip then pcont.push "skip=#{v}&"; end
        if k == :source then pcont.push "sourceDictionary=#{v}&"; end
        if k == :defdict then pcont.push "sourceDictionaries=#{v}&"; end
        if k == :tformat then pcont.push "typeFormat=#{v}&"; end
        if k == :wlmi then pcont.push "wlmi=#{v}&"; end
      }
      apikey = ENV['WORDNIK']
      pcont.push "api_key=#{apikey}"
      url = "#{word}#{pcont.join}"
      request = HTTPI::Request.new(url)
      getter = HTTPI.get(request)
      result = getter.body
    end

    # Fetches definitions from Wordnik. Parts include:
    # 'noun,adjective,verb,adverb,interjection,pronoun,
    # preposition,abbreviation,affix,article,auxiliary-verb,
    # conjunction,definite-article,family-name,given-name,
    # idiom,imperative,noun-plural,noun-posessive,
    # past-participle,phrasal-prefix,proper-noun,
    # proper-noun-plural,proper-noun-posessive,suffix,
    # verb-intransitive,verb-transitive'
    #
    # @param search [String] The word or phrase to search for.
    # @param part [String] Comma-separated list of parts of speech.
    # @param params [Hash] The search parameters to use.
    def get_def(search, part, params)
      func, label, result = 'definitions', 'Definition', nil
      if part != nil then params[:part] = part; end
      defi = Lyracyst::Wordnik.new
      result = defi.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        x, y = 0, result.length - 1
        while x <= y
          d = result[x]
          text = d['text']
          part = d['partOfSpeech']
          defi.label(label)
          print Rainbow("#{part} - ").bright
          puts "#{text}"
          x += 1
        end
      else
        puts 'Wordnik returned an empty string.'
      end
    end

    # Fetches examples from Wordnik.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_ex(search, params)
      func, label, result = 'examples', 'Example', nil
      exam = Lyracyst::Wordnik.new
      result = exam.get_word(search, func, params, result)
      result = MultiJson.load(result)
      result = result['examples']
      if result != nil
        x, y = 0, result.length - 1
        while x <= y
          ex = result[x]
          title = ex['title']
          text = ex['text']
          url = ex['url']
          exam.label(label)
          print Rainbow("#{title} - ").bright
          puts "#{text} - #{url}"
          x += 1
        end
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end

    # Fetches pronunciations from Wordnik. Types include ['ahd'
    # 'arpabet', 'gcide-diacritical', 'IPA']
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    # @param ptype [String] Pronunciation type.
    def get_pro(search, params, ptype)
      func, label, result = 'pronunciations', 'Pronunciation', nil
      if ptype != nil then params[:tformat] = ptype; end
      pron = Lyracyst::Wordnik.new
      result = pron.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        x, y = 0, result.length - 1
        while x <= y
          pro = result[x]
          rawtype = pro['rawType']
          raw = pro['raw']
          pron.label(label)
          print Rainbow("- ").bright
          puts "#{raw} - #{rawtype}"
          x += 1
        end
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end

    # Fetches related words from Wordnik. Types include ['synonym',
    # 'antonym', 'variant', 'equivalent', 'cross-reference',
    # 'related-word', 'rhyme', 'form', 'etymologically-related-term',
    # 'hypernym', 'hyponym', 'inflected-form', 'primary', 'same-context',
    # 'verb-form', 'verb-stem']
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    # @param reltypes [String] Relationship type.
    def get_rel(search, params, reltypes)
      func, label, result = 'relatedWords', 'Related words', nil
      if reltypes != nil then params[:reltypes] = reltypes; end
      rel = Lyracyst::Wordnik.new
      result = rel.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        x, y = 0, result.length - 1
        while x <= y
          re = result[x]
          words, type = re['words'], re['relationshipType']
          rel.label(label)
          print Rainbow("#{type} - ").bright
          puts "#{words.join(', ')}"
          x += 1
        end
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end

    # Fetches hyphenations from Wordnik.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_hyph(search, params)
      func, label, result = 'hyphenation', 'Hyphenation', nil
      hyph = Lyracyst::Wordnik.new
      result = hyph.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        x, y, hcont = 0, result.length - 1, []
        hyph.label(label)
        print Rainbow("- ").bright
        while x <= y
          hy = result[x]
          ht = hy['text']
          if hy['type'] == 'stress'
            hcont.push Rainbow(ht).red.bright
          elsif hy['type'] == 'secondary stress'
            hcont.push Rainbow(ht).bright
          else
            hcont.push ht
          end
          x += 1
        end
        puts hcont.join('-')
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end

    # Fetches bi-gram phrases from Wordnik.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_phr(search, params)
      func, label, result = 'phrases', 'Bi-gram phrases', nil
      phr = Lyracyst::Wordnik.new
      result = phr.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        x, y, phcont = 0, result.length - 1, []
        phr.label(label)
        print Rainbow("- ").bright
        while x <= y
          ph = result[x]
          one = ph['gram1']
          two = ph['gram2']
          if one == search
            item = "#{Rainbow(one).bright} #{two}"
          else
            item = "#{one} #{Rainbow(two).bright}"
          end
          phcont.push item
          x += 1
        end
        puts "#{phcont.join('|')}"
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end

    # Fetches etymologies from Wordnik.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_et(search, params)
      func, label, result = 'etymologies', 'Etymology', nil
      #etymology = Lyracyst::Wordnik.new
      #result = etymology.get_word(search, func, params, result)
      result = get_word(search, func, params, result)
      if result != nil && result != '[]'
        result = MultiJson.load(result)
        a, b, cont = 0, result.length - 1, []
        while a <= b
          xml = result[a]
          xml = MultiXml.parse(xml)
          root = xml['ety']
          content, ets, er = root['__content__'], root['ets'], root['er']
          #etymology.label(label)
          label(label)
          print Rainbow("- ").bright
          print "#{content} - "
          if ets != nil
            c, d, etscont = 0, ets.length - 1, []
            while c <= d
              if d == 0
                etsc = ets['__content__']
                etscont.push etsc
              else
                etsc = ets[c]
                etscont.push etsc['__content__']
              end
              c += 1
            end
            print "#{etscont.join('|')}"
          else
            puts ''
          end
          if er != nil
            print ' - '
            e, f, ercont = 0, er.length - 1, []
            while e <= f
              if f == 0
                erc = er['__content__']
                ercont.push erc
              else
                erc = er[e]
                ercont.push erc['__content__']
              end
              e += 1
            end
            print "#{ercont.join('|')}"
          else
            puts ''
          end
          a += 1
          puts ''
        end
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end

  end
end
