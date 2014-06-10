# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map { |lib| require lib }

module Lyracyst
  class Wordnik
    # Fetches pronunciations from Wordnik. Types include ['ahd'
    # 'arpabet', 'gcide-diacritical', 'IPA']
    class Pronounce
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      # @param ptype [String] Pronunciation type.
      def get_pro(search, params, ptype)
        func, label, result = 'pronunciations', 'Pronunciation', nil
        if ptype != nil then params[:tformat] = ptype; end
        pron = Lyracyst::Wordnik.new
        result = pron.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          x, y = 0, result.length - 1
          type = { 'type' => 'pronunciation' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          while x <= y
            pro = result[x]
            rawtype = pro['rawType']
            raw = pro['raw']
            Lyracyst.label(label)
            puts "#{raw}|#{rawtype}|"
            pronunciation = { 'pronunciation' => raw }
            ptype = { 'ptype' => rawtype }
            Lyracyst.tofile(pronunciation)
            Lyracyst.tofile(ptype)
            x += 1
          end
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
    end
  end
end
