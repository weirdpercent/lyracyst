# coding: utf-8
%w{httpi multi_json rainbow}.map {|lib| require lib}

module Lyracyst
  # This class uses the Rhymebrain API to fetch rhymes, word info, and portmanteaus.
  class Rhymebrain
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

    # Prints colored element label.
    #
    # @param label [String] The label to print
    def label(label)
      print Rainbow("[").blue.bright
      print Rainbow(label).green.bright
      print Rainbow("] ").blue.bright
    end

    # Fetches dynamically generated URL. Functions are Rhymes,
    # WordInfo, and Portmaneaus.
    #
    # @param search [String] The word or phrase to search for.
    # @param func [String] The search function to use.
    # @param params [Hash] The search parameters to use.
    # @param result [String] The search response.
    def get_word(search, func, params, result)
      prefix = "http://rhymebrain.com/talk?function=get"
      word, pcont = "#{prefix}#{func}&word=#{search}&", []
      params.map { |k,v|
        if k == :lang then pcont.push "lang=#{v}&"; end
        if k == :max && k != nil then pcont.push "maxResults=#{v}&"; end
      }
      url = "#{word}#{pcont.join}"
      request = HTTPI::Request.new(url)
      getter = HTTPI.get(request)
      result = getter.body
    end

    # Fetches rhymes using the Rhymebrain API.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_rhyme(search, params)
      func, label, result = 'Rhymes', 'Rhymes', nil
      rh = Lyracyst::Rhymebrain.new
      result = rh.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        a, b, rcont = 0, result.length - 1, []
        while a <= b
          match = result[a]
          rhyme = match['word']
          rcont.push rhyme
          a += 1
        end
        rh.label(label)
        print Rainbow('- ').bright
        print rcont.join(Rainbow('|').bright)
        puts ''
      end
    end

    # Fetches word info using the Rhymebrain API.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_info(search, params)
      func, label, result = 'WordInfo', 'Word info', nil
      wi = Lyracyst::Rhymebrain.new
      result = wi.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        word = result['word']
        pron = result['pron']
        ipa = result['ipa']
        flags = result['flags']
        syllables = result['syllables']
        wi.label(label)
        print Rainbow('- Word: ').bright
        print "#{word}"
        print Rainbow('|Pronunciation: ').bright
        print "#{pron}"
        print Rainbow('|IPA: ').bright
        print "#{ipa}"
        print Rainbow('|Syllables: ').bright
        print "#{syllables}"
        print Rainbow('|Flags: ').bright
        fcont = []
        if flags =~ /a/ then fcont.push 'The word is offensive.'; end
        if flags =~ /b/ then fcont.push 'The word might be found in most dictionaries.'; end
        if flags =~ /c/ then fcont.push 'The pronunciation is known with confidence. It was not automatically generated.'; end
          puts "#{fcont.join(Rainbow('|').bright)}"
      end
    end

    # Fetches portmaneaus using the Rhymebrain API.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_port(search, params)
      func, label, result = 'Portmanteaus', 'Portmanteaus', nil
      pm = Lyracyst::Rhymebrain.new
      result = pm.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        a, b, pmcont = 0, result.length - 1, []
        while a <= b
          match = result[a]
          roots = match['source']
          combo = match['combined']
          both = "#{Rainbow('Root words: ').bright}#{roots}#{Rainbow('| Combination: ').bright}#{combo}"
          pmcont.push both
          a += 1
        end
        pm.label(label)
        print Rainbow('- ').bright
        print pmcont.join(Rainbow('|').bright)
        puts ''
      end
    end

  end
end
