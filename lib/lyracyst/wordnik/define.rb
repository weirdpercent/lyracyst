# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map { |lib| require lib }

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
        func, result = 'definitions', nil
        if part != nil then params[:part] = part; end
        defi = Lyracyst::Wordnik.new
        result = defi.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          st = { 'searchterm' => search }
          type = { 'type' => 'definition' }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          e = Lyracyst::Wordnik::Define.new
          e.define_extra(result)
        else
          puts 'Wordnik returned an empty string.'
        end
      end
      # Extra repetitive tasks.
      #
      # @param result [Array] List of hashes to process.
      def define_extra(result)
        x, y, label = 0, result.length - 1, 'Definition'
        while x <= y
          d = result[x]
          text = d['text']
          part = d['partOfSpeech']
          Lyracyst.label(label)
          print Rainbow("#{part}|").bright
          puts "#{text}|"
          part = { 'part' => part }
          text = { 'text' => text }
          Lyracyst.tofile(part)
          Lyracyst.tofile(text)
          x += 1
        end
      end
    end
  end
end
