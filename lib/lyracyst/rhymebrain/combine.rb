# coding: utf-8
%w{httpi multi_json rainbow}.map {|lib| require lib}

module Lyracyst
  class Rhymebrain
    # Fetches portmanteaus using the Rhymebrain API.
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
          both = "#{Rainbow('Root words➜').bright}#{roots}#{Rainbow('Combination➜').bright}#{combo}"
          pmcont.push both
          a += 1
        end
        Lyracyst.label(label)
        puts pmcont.join(Rainbow('➜').bright)
      end
    end
  end
end
