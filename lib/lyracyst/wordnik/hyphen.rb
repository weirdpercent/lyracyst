# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map { |lib| require lib }

module Lyracyst
  class Wordnik
    # Fetches hyphenations from Wordnik.
    class Hyphen
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_hyph(search, params)
        func, label, result = 'hyphenation', 'Hyphenation', nil
        hyph = Lyracyst::Wordnik.new
        result = hyph.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          Lyracyst.label(label)
          t = { 'type' => 'hyphenation' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(t)
          e = Lyracyst::Wordnik::Hyphen.new
          e.hyphen_extra(result)
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
      # Extra repetitive tasks.
      #
      # @param result [Array] List of hashes to process.
      def hyphen_extra(result)
        x, y, hcont = 0, result.length - 1, []
        while x <= y
          hy = result[x]
          ht = hy['text']
          if hy['type'] == 'stress'
            stress = 'primary'
            sh = { ht => stress }
            h = { 'syllable' => sh }
            Lyracyst.tofile(h)
            hcont.push Rainbow(ht).red.bright
          elsif hy['type'] == 'secondary stress'
            stress = 'secondary'
            sh = { ht => stress }
            h = { 'syllable' => sh }
            Lyracyst.tofile(h)
            hcont.push Rainbow(ht).bright
          else
            h = { 'syllable' => ht }
            Lyracyst.tofile(h)
            hcont.push ht
          end
          x += 1
        end
        puts hcont.join('-')
      end
    end
  end
end
