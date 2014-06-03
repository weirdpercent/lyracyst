# coding: utf-8
%w{httpi multi_json multi_xml rainbow}.map {|lib| require lib}

module Lyracyst
  class Wordnik
    class Example
      # Fetches examples from Wordnik.
      #
      # @param search [String] The word or phrase to search for.
      # @param params [Hash] The search parameters to use.
      def get_ex(search, params)
        func, label, result = 'examples', 'Example', nil
        exam = Lyracyst::Wordnik.new
        result = exam.get_word(search, func, params, result)
        result = MultiJson.load(result)
        result = result['examples']
        if result != nil
          x, y = 0, result.length - 1
          while x <= y
            ex = result[x]
            title = ex['title']
            text = ex['text']
            url = ex['url']
            Lyracyst.label(label)
            print Rainbow("#{title}➜").bright
            puts "#{text}➜#{url}➜"
            ty = { 'type' => 'example' }
            ti = { 'title' => title }
            te = { 'text' => text }
            u = { 'url' => url }
            Lyracyst.tofile(ty)
            Lyracyst.tofile(ti)
            Lyracyst.tofile(te)
            Lyracyst.tofile(u)
            x += 1
          end
        else
          puts 'Wordnik failed to fetch word info.'
        end
      end
    end
  end
end
