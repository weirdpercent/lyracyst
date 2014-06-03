# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map {|lib| require lib}

module Lyracyst
  class Wordnik
    # Fetches bi-gram phrases from Wordnik.
    class Phrase
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_phr(search, params)
        func, label, result = 'phrases', 'Bi-gram phrases', nil
        phr = Lyracyst::Wordnik.new
        result = phr.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          x, y, phcont = 0, result.length - 1, []
          Lyracyst.label(label)
          type = { 'type' => 'phrase' }
          Lyracyst.tofile(type)
          while x <= y
            ph = result[x]
            one = ph['gram1']
            two = ph['gram2']
            g1 = { 'gram1' => one }
            g2 = { 'gram2' => two }
            Lyracyst.tofile(g1)
            Lyracyst.tofile(g2)
            if one == search
              item = "#{Rainbow(one).bright}➜#{two}"
            else
              item = "#{one}➜#{Rainbow(two).bright}"
            end
            phcont.push item
            x += 1
          end
          puts "#{phcont.join('➜')}"
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
    end
  end
end
