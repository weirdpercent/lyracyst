# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map { |lib| require lib }

module Lyracyst
  class Wordnik
    # Fetches examples from Wordnik.
    class Example
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_ex(search, params)
        func, result = 'examples', nil
        exam = Lyracyst::Wordnik.new
        result = exam.get_word(search, func, params, result)
        result = MultiJson.load(result)
        result = result['examples']
        if result != nil
          st = { 'searchterm' => search }
          ty = { 'type' => 'example' }
          Lyracyst.tofile(st)
          Lyracyst.tofile(ty)
          e = Lyracyst::Wordnik::Example.new
          e.ex_extra(result)
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
      # Extra repetitive tasks.
      #
      # @param result [Array] List of hashes to process.
      def ex_extra(result)
        x, y, label = 0, result.length - 1, 'Example'
        while x <= y
          ex = result[x]
          title = ex['title']
          text = ex['text']
          url = ex['url']
          Lyracyst.label(label)
          print Rainbow("#{title}|").bright
          puts "#{text}|#{url}|"
          ti = { 'title' => title }
          te = { 'text' => text }
          u = { 'url' => url }
          Lyracyst.tofile(ti)
          Lyracyst.tofile(te)
          Lyracyst.tofile(u)
          x += 1
        end
      end
    end
  end
end
