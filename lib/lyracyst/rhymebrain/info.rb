# coding: utf-8
%w{httpi multi_json rainbow}.map { |lib| require lib }

module Lyracyst
  class Rhymebrain
    # Fetches word info using the Rhymebrain API.
    class Info
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_info(search, params)
        func, label, result = 'WordInfo', 'Word info', nil
        wi = Lyracyst::Rhymebrain.new
        result = wi.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          Lyracyst.label(label)
          type = { 'type' => 'word info' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          e = Lyracyst::Rhymebrain::Info.new
          e.info_extra(result)
        end
      end
      # Extra repetitive taks.
      #
      # @param result [Array] Hash to process.
      def info_extra(result)
        word = result['word']
        pron = result['pron']
        ipa = result['ipa']
        flags = result['flags']
        syllables = result['syllables']
        print Rainbow('Word|').bright
        print "#{word}"
        print Rainbow('|ARPABET|').bright
        print "#{pron}"
        print Rainbow('|IPA|').bright
        print "#{ipa}"
        print Rainbow('|Syllables|').bright
        print "#{syllables}"
        print Rainbow('|Flags|').bright
        word = { 'word' => word }
        pron = { 'ARPABET pronunciation' => pron }
        ipa = { 'IPA pronunciation' => ipa }
        syllables = { 'syllables' => syllables }
        Lyracyst.tofile(word)
        Lyracyst.tofile(pron)
        Lyracyst.tofile(ipa)
        Lyracyst.tofile(syllables)
        f = Lyracyst::Rhymebrain::Info.new
        f.flag_extra(flags)
      end
      # Extra flag tasks.
      #
      # @param flags [String] ABC flags to process.
      def flag_extra(flags)
        fcont = []
        if flags =~ /a/
          flag = { 'aflag' => 'The word is offensive.' }
          fcont.push Rainbow(flag['aflag']).red.bright
          Lyracyst.tofile(flag)
        end
        if flags =~ /b/
          flag = { 'bflag' => 'The word might be found in most dictionaries.' }
          fcont.push flag['bflag']
          Lyracyst.tofile(flag)
        end
        if flags =~ /c/
          flag = { 'cflag' => 'The pronunciation is known with confidence. It was not automatically generated.' }
          fcont.push flag['cflag']
          Lyracyst.tofile(flag)
        end
        puts "#{fcont.join(Rainbow('|').bright)}"
      end
    end
  end
end
