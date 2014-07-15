# coding: utf-8
require 'multi_xml'
require 'open-uri'

module Lyracyst
  class Wolfram
    # Fetches results for a given phrase.
    class Fetch
      # This method calls {Lyracyst::Wolfram::Pod#numpods}
      # and {Lyracyst::Wolfram::Assume#assume}.
      #
      # @param search [String] The phrase to search for.
      # @param params [Hash] The search parameters to use.
      def fetch(search, params)
        Lyracyst.label('Fetch')
        search = URI.encode(search)
        wo = Lyracyst::Wolfram.new
        result = wo.get_phrase(search, params)
        result = MultiXml.parse(result)
        result = result['queryresult']
        Lyracyst.label('Success')
        print "#{result['success']}"
        Lyracyst.label('Error')
        print "#{result['error']}"
        Lyracyst.label('Version')
        print "#{result['version']}"
        Lyracyst.label('Datatypes')
        puts "#{result['datatypes']}"
        Lyracyst.label('Pod Count')
        puts "#{result['numpods']}"
        Lyracyst.label('Timed Out')
        print "#{result['timedout']}"
        Lyracyst.label('Parse Timed Out')
        print "#{result['parsetimedout']}"
        Lyracyst.label('Related')
        puts "#{result['related']}"
        Lyracyst.label('Recalculate')
        puts "#{result['recalculate']}"
        p = result['pod']
        np = result ['numpods'].to_i
        nump = Lyracyst::Wolfram::Pod.new
        nump.numpods(p, np)
        if params[:fassu]
          assumptions = result['assumptions']
          a = Lyracyst::Wolfram::Assume.new
          a.assume(assumptions)
        end
      end
    end
  end
end
