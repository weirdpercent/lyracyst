# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map { |lib| require lib }

module Lyracyst
  # Wordnik.com's service provides definitions, examples,
  # related words, pronunciations, hyphenation, phrases,
  # and etymologies.
  class Wordnik
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
      params.map { |k, v|
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
  end
end
