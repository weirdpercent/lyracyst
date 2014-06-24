# coding: utf-8
%w{httpi multi_json rainbow}.map { |lib| require lib }

module Lyracyst
  class Rhymebrain
    # Fetches rhymes using the Rhymebrain API.
    class Rhyme
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_rhyme(search, params)
        func, label, result = 'Rhymes', 'Rhymes', nil
        rh = Lyracyst::Rhymebrain.new
        result = rh.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          Lyracyst.label(label)
          type = { 'type' => 'rhyme' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          e = Lyracyst::Rhymebrain::Rhyme.new
          e.rhyme_extra(result)
        end
      end
      # Extra repetitive tasks.
      #
      # @param result [Array] List of hashes to process.
      def rhyme_extra(result)
        a, b, rcont = 0, result.length - 1, []
        while a <= b
          match = result[a]
          rhyme = match['word']
          rcont.push rhyme
          rhyme = { 'rhyme' => rhyme }
          a += 1
        end
        Lyracyst.tofile("#{rcont.join(',')}")
        puts rcont.join(Rainbow('|').bright)
      end
    end
  end
end
