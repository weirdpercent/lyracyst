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
        rtype = result['result_type']
        list = result['list']
        Lyracyst.label(label)
        print Rainbow("|Tags|#{tags}|Type|#{rtype}").bright
        x, y, dcont = 0, list.length - 1, []
        if $fmt != nil
          type = { 'type' => 'urban' }
          tags = { 'tags' => tags }
          rtype = { 'result type' => rtype }
          list = { 'list' => list }
          $tofile.push type
          $tofile.push tags
          $tofile.push rtype
          $tofile.push list
        end
        while x <= y
          obj = list[x]
          author = obj['author']
          link = obj['permalink']
          defi = obj['definition']
          ex = obj['example']
          puts "|#{defi}|#{ex}|#{author}|#{link}"
          if $fmt != nil
            author = { 'author' => author }
            link = { 'link' => link }
            defi = { 'definition' => defi }
            ex = { 'example' => ex }
            $tofile.push defi
            $tofile.push ex
            $tofile.push author
            $tofile.push link
          end
          x += 1
        end
      end
    end
  end
end
