# coding: utf-8
%w{httpi multi_json rainbow}.map {|lib| require lib}

module Lyracyst
  # This class uses the Rhymebrain API to fetch rhymes, word info, and portmanteaus.
  class Rhymebrain
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
  end
end
