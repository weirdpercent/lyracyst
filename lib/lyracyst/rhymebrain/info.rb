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
          type = { 'type' => 'word info' }
          Lyracyst.tofile(type)
          word = result['word']
          pron = result['pron']
          ipa = result['ipa']
          flags = result['flags']
          syllables = result['syllables']
          Lyracyst.label(label)
          print Rainbow('Word|').bright
          print "#{word}"
          print Rainbow('|Pronunciation|').bright
          print "#{pron}"
          print Rainbow('|IPA|').bright
          print "#{ipa}"
          print Rainbow('|Syllables|').bright
          print "#{syllables}"
          print Rainbow('|Flags|').bright
          word = { 'word' => word }
          pron = { 'pronunciation' => pron }
          ipa = { 'IPA pronunciation' => ipa }
          syllables = { 'syllables' => syllables }
          Lyracyst.tofile(word)
          Lyracyst.tofile(pron)
          Lyracyst.tofile(ipa)
          Lyracyst.tofile(syllables)
          fcont = []
          if flags =~ /a/
            fcont.push Rainbow('The word is offensive.').red.bright
            flag = { 'aflag' => 'The word is offensive.' }
            Lyracyst.tofile(flag)
          end
          if flags =~ /b/
            fcont.push 'The word might be found in most dictionaries.'
            flag = { 'bflag' => 'The word might be found in most dictionaries.' }
            Lyracyst.tofile(flag)
          end
          if flags =~ /c/
            fcont.push 'The pronunciation is known with confidence. It was not automatically generated.'
            flag = { 'cflag' => 'The pronunciation is known with confidence. It was not automatically generated.' }
            Lyracyst.tofile(flag)
          end
          puts "#{fcont.join(Rainbow('|').bright)}"
        end
      end
    end
  end
end
