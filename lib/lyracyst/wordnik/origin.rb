# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map { |lib| require lib }

module Lyracyst
  class Wordnik
    # Fetches etymologies from Wordnik.
    class Origin
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_et(search, params)
        func, result = 'etymologies', nil
        etymology = Lyracyst::Wordnik.new
        e = Lyracyst::Wordnik::Origin.new
        result = etymology.get_word(search, func, params, result)
        if result != nil && result != '[]'
          result = MultiJson.load(result)
          type = { 'type' => 'etymology' }
          st = { 'searchterm' => search }
          Lyracyst.tofile(st)
          Lyracyst.tofile(type)
          e.origin_extra(result)
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
      # Extra repetitive tasks.
      #
      # @param result [Array] List of hashes to process.
      def origin_extra(result)
        ee = Lyracyst::Wordnik::Origin.new
        a, b, label = 0, result.length - 1, 'Etymology'
        while a <= b
          xml = result[a]
          xml = MultiXml.parse(xml)
          root = xml['ety']
          content, ets, er = root['__content__'], root['ets'], root['er']
          root = { 'root' => content }
          Lyracyst.tofile(root)
          Lyracyst.label(label)
          print "#{content}|"
          if ets != nil
            ee.origin_extra2(ets)
          else
            puts ''
          end
          if er != nil
            print '|'
            ee.origin_extra2(er)
          else
            puts ''
          end
          a += 1
          puts ''
        end
      end
      # Extra repetitive tasks.
      #
      # @param obj [Hash] Object hash to process.
      def origin_extra2(obj)
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
        print "#{container.join('|')}"
        node = { 'node' => container.join(',') }
        Lyracyst.tofile(node)
      end
    end
  end
end
