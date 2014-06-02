# coding: utf-8
%w{httpi multi_json rainbow}.map {|lib| require lib}

module Lyracyst
  class Rhymebrain
    class Info
      # Fetches word info using the Rhymebrain API.
      #
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_info(search, params)
        func, label, result = 'WordInfo', 'Word info', nil
        wi = Lyracyst::Rhymebrain.new
        result = wi.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          if $fmt != nil
            type = { 'type' => 'word info' }
            $tofile.push type
          end
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
          if $fmt != nil
            word = { 'word' => word }
            pron = { 'pronunciation' => pron }
            ipa = { 'IPA pronunciation' => ipa }
            syllables = { 'syllables' => syllables}
            $tofile.push word
            $tofile.push pron
            $tofile.push ipa
            $tofile.push syllables
          end
          fcont = []
          if flags =~ /a/
            fcont.push Rainbow('The word is offensive.').red.bright
            if $fmt != nil
              flag = { 'flag' => 'The word is offensive.'}
              $tofile.push flag
            end
          end
          if flags =~ /b/
            fcont.push 'The word might be found in most dictionaries.'
            if $fmt != nil
              flag = { 'flag' => 'The word might be found in most dictionaries.'}
              $tofile.push flag
            end
          end
          if flags =~ /c/
            fcont.push 'The pronunciation is known with confidence. It was not automatically generated.'
            if $fmt != nil
              flag = { 'flag' => 'The pronunciation is known with confidence. It was not automatically generated.'}
              $tofile.push flag
            end
          end
          puts "#{fcont.join(Rainbow('|').bright)}"
        end
      end
    end
  end
end
