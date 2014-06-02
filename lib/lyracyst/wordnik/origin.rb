# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map {|lib| require lib}

module Lyracyst
  class Wordnik
    class Origin
      # Fetches etymologies from Wordnik.
      #
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_et(search, params)
        func, label, result = 'etymologies', 'Etymology', nil
        etymology = Lyracyst::Wordnik.new
        extra = Lyracyst::Wordnik::Origin.new
        result = etymology.get_word(search, func, params, result)
        if result != nil && result != '[]'
          result = MultiJson.load(result)
          a, b, cont = 0, result.length - 1, []
          if $fmt != nil
            type = { 'type' => 'etymology'}
            $tofile.push type
          end
          while a <= b
            xml = result[a]
            xml = MultiXml.parse(xml)
            root = xml['ety']
            content, ets, er = root['__content__'], root['ets'], root['er']
            if $fmt != nil
              root = { 'root' => content }
              $tofile.push root
            end
            Lyracyst.label(label)
            print "#{content}|"
            if ets != nil
              extra.origin_extra(ets)
            else
              puts ''
            end
            if er != nil
              print '|'
              extra.origin_extra(er)
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
            if $fmt != nil
              node = { 'node' => content }
              $tofile.push node
            end
          else
            content = obj[a]
            container.push content['__content__']
            if $fmt != nil
              node = { 'node' => content}
              $tofile.push node
            end
          end
        a += 1
        end
        print "#{container.join('|')}"
      end
    end
  end
end
