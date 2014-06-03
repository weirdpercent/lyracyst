# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map {|lib| require lib}

module Lyracyst
  class Wordnik
    # Fetches definitions from Wordnik. Parts include:
    # 'noun,adjective,verb,adverb,interjection,pronoun,
    # preposition,abbreviation,affix,article,auxiliary-verb,
    # conjunction,definite-article,family-name,given-name,
    # idiom,imperative,noun-plural,noun-posessive,
    # past-participle,phrasal-prefix,proper-noun,
    # proper-noun-plural,proper-noun-posessive,suffix,
    # verb-intransitive,verb-transitive'
    class Define
      # @param search [String] The word or phrase to search for.
      # @param part [String] Comma-separated list of parts of speech.
      # @param params [Hash] The search parameters to use.
      def get_def(search, part, params)
        func, label, result = 'definitions', 'Definition', nil
        if part != nil then params[:part] = part; end
        defi = Lyracyst::Wordnik.new
        result = defi.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          x, y = 0, result.length - 1
          while x <= y
            d = result[x]
            text = d['text']
            part = d['partOfSpeech']
            Lyracyst.label(label)
            print Rainbow("#{part}|").bright
            puts "#{text}|"
            type = { 'type' => 'definition' }
            part = { 'part' => part }
            text = { 'text' => text}
            Lyracyst.tofile(type)
            Lyracyst.tofile(part)
            Lyracyst.tofile(text)
            x += 1
          end
        else
          puts 'Wordnik returned an empty string.'
        end
      end
    end
  end
end
