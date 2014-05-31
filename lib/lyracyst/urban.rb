%w{httpi multi_json rainbow}.map {|lib| require lib}
module Lyracyst
  class Urban
    # Fetches URL.
    #
    # @param search [String] The word or phrase to search for.
    # @param result [String] The search response.
    def get_word(search, result)
      prefix = "http://api.urbandictionary.com/v0/define?term="
      url = "#{prefix}#{search}"
      request = HTTPI::Request.new(url)
      getter = HTTPI.get(request)
      result = getter.body
    end
    class Define
      # Fetches definitions and examples from Urbandictionary.com.
      #
      # @param search [String] The word or phrase to search for.
      def get_def(search)
        label, result = 'Urban Dictionary', nil
        ur = Lyracyst::Urban.new
        result = ur.get_word(search, result)
        result = MultiJson.load(result)
        tags = result['tags']
        type = result['result_type']
        list = result['list']
        Lyracyst.label(label)
        print Rainbow("➜Tags➜#{tags}➜Type➜#{type}").bright
        x, y, dcont = 0, list.length - 1, []
        while x <= y
          obj = list[x]
          author = obj['author']
          link = obj['permalink']
          defi = obj['definition']
          ex = obj['example']
          puts "➜#{defi}➜#{ex}➜#{author}➜#{link}"
          x += 1
        end
      end
    end
  end
end
