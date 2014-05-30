# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map {|lib| require lib}

module Lyracyst
  class Wordnik
    # Fetches related words from Wordnik. Types include ['synonym',
    # 'antonym', 'variant', 'equivalent', 'cross-reference',
    # 'related-word', 'rhyme', 'form', 'etymologically-related-term',
    # 'hypernym', 'hyponym', 'inflected-form', 'primary', 'same-context',
    # 'verb-form', 'verb-stem']
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    # @param reltypes [String] Relationship type.
    def get_rel(search, params, reltypes)
      func, label, result = 'relatedWords', 'Related words', nil
      if reltypes != nil then params[:reltypes] = reltypes; end
      rel = Lyracyst::Wordnik.new
      result = rel.get_word(search, func, params, result)
      result = MultiJson.load(result)
      if result != nil
        x, y = 0, result.length - 1
        while x <= y
          re = result[x]
          words, type = re['words'], re['relationshipType']
          Lyracyst.label(label)
          print Rainbow("#{type}➜").bright
          puts "#{words.join('➜')}"
          x += 1
        end
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end

  end
end
