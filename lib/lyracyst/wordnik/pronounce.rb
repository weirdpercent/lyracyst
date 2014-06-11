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
        func, result = 'pronunciations', nil
        if ptype != nil then params[:tformat] = ptype; end
        pron = Lyracyst::Wordnik.new
        result = pron.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          type = { 'type' => 'pronunciation' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          e = Lyracyst::Wordnik::Pronounce.new
          e.pro_extra(result)
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
      # Extra repetitive tasks.
      #
      # @param result [Array] List of hashes to process.
      def pro_extra(result)
        x, y, label = 0, result.length - 1, 'Pronunciation'
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
      end
    end
  end
end
