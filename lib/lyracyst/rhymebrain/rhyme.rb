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
          a, b, rcont = 0, result.length - 1, []
          type = { 'type' => 'rhyme' }
          Lyracyst.tofile(type)
          while a <= b
            match = result[a]
            rhyme = match['word']
            rcont.push rhyme
            rhyme = { 'rhyme' => rhyme }
            Lyracyst.tofile(rhyme)
            a += 1
          end
          Lyracyst.label(label)
          print rcont.join(Rainbow('|').bright)
          puts ''
        end
      end
    end
  end
end
