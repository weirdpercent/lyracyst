# coding: utf-8
%w{httpi multi_json rainbow}.map { |lib| require lib }

module Lyracyst
  class Rhymebrain
    # Fetches portmanteaus using the Rhymebrain API.
    class Combine
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_port(search, params)
        func, result = 'Portmanteaus', nil
        pm = Lyracyst::Rhymebrain.new
        result = pm.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          type = { 'type' => 'portmanteau' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          e = Lyracyst::Rhymebrain::Combine.new
          e.comb_extra(result)
        end
      end
      # Extra repetitive tasks
      #
      # @param result [Array] List of hashes to process.
      def comb_extra(result)
        a, b, pmcont, label = 0, result.length - 1, [], 'Portmanteau'
        while a <= b
          match = result[a]
          roots = match['source']
          combo = match['combined']
          both = "#{Rainbow('Root words|').bright}#{roots}#{Rainbow('Combination|').bright}#{combo}"
          roots = { 'roots' => roots }
          combo = { 'combo' => combo }
          Lyracyst.tofile(roots)
          Lyracyst.tofile(combo)
          pmcont.push both
          a += 1
        end
        Lyracyst.label(label)
        puts pmcont.join(Rainbow('|').bright)
      end
    end
  end
end
