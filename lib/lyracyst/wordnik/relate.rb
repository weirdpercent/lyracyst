# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map { |lib| require lib }

module Lyracyst
  class Wordnik
    # Fetches related words from Wordnik. Types include ['synonym',
    # 'antonym', 'variant', 'equivalent', 'cross-reference',
    # 'related-word', 'rhyme', 'form', 'etymologically-related-term',
    # 'hypernym', 'hyponym', 'inflected-form', 'primary', 'same-context',
    # 'verb-form', 'verb-stem']
    class Relate
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      # @param reltypes [String] Relationship type.
      def get_rel(search, params, reltypes)
        func, result = 'relatedWords', nil
        if reltypes != nil then params[:reltypes] = reltypes; end
        rel = Lyracyst::Wordnik.new
        result = rel.get_word(search, func, params, result)
        result = MultiJson.load(result)
        if result != nil
          type = { 'type' => 'related words' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          e = Lyracyst::Wordnik::Relate.new
          e.rel_extra(result)
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
      # Extra repetitive tasks.
      #
      # @param result [Array] List of hashes to process.
      def rel_extra(result)
        x, y, label = 0, result.length - 1, 'Related words'
        while x <= y
          re = result[x]
          words, type = re['words'], re['relationshipType']
          Lyracyst.label(label)
          print Rainbow("#{type}|").bright
          puts "#{words.join('|')}"
          words = { 'words' => words }
          rtype = { 'relationship type' => type }
          Lyracyst.tofile(words)
          Lyracyst.tofile(rtype)
          x += 1
        end
      end
    end
  end
end
