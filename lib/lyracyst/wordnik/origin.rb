# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map {|lib| require lib}

module Lyracyst
  class Wordnik
    # Fetches etymologies from Wordnik.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_et(search, params)
      func, label, result = 'etymologies', 'Etymology', nil
      etymology = Lyracyst::Wordnik.new
      result = etymology.get_word(search, func, params, result)
      if result != nil && result != '[]'
        result = MultiJson.load(result)
        a, b, cont = 0, result.length - 1, []
        while a <= b
          xml = result[a]
          xml = MultiXml.parse(xml)
          root = xml['ety']
          content, ets, er = root['__content__'], root['ets'], root['er']
          Lyracyst.label(label)
          print "#{content}➜"
          if ets != nil
            etymology.origin_extra(ets)
          else
            puts ''
          end
          if er != nil
            print '➜'
            etymology.origin_extra(er)
          else
            puts ''
          end
          a += 1
          puts ''
        end
      else
        puts 'Wordnik failed to fetch word info.'
      end
    end
    def origin_extra(obj)
      a, b, container = 0, obj.length - 1, []
      while a <= b
        if b == 0
          content = obj['__content__']
          container.push content
        else
          content = obj[a]
          container.push content['__content__']
        end
      a += 1
      end
      print "#{container.join('➜')}"
    end
  end
end
