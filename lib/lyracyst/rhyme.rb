# coding: utf-8
require 'httpi'
require 'multi_json'
module Lyracyst
  # The Rhyme class uses the ARPABET Heroku app to fetch rhymes.
  class Rhyme
    # ARPA created ARPABET decades ago to find words that
    # rhyme. The technology is still quite relevant today.
    # This program uses the Heroku app based on ARPABET.
    # This method calls {Rhyme#http}.
    #
    # @param search [String] The word or phrase to search for.
    def rhyme(search, result)
      url = "http://arpabet.heroku.com/words/#{search}"
      rh = Lyracyst::Rhyme.new
      rtype = ''
      result = rh.http(url, result)
      resulta = MultiJson.load(result)
      print "Rhymes with: "
      resulta.map { |x|
        print " #{x}"
      }
      print "\n"
    end
    # Opens URL and returns response. HTTPI supports multiple HTTP
    # clients, and selects the 'best' in the following order:
    # httpclient, curb, em_http, excon, net_http, net_http_persistent.
    # For C extensions, curb is recommended. For pure Ruby, use excon.
    # You can specify a client to use like this:
    # request = HTTPI::Request.new(url)
    # HTTPI.get(request, :curb)
    #
    # @param url [String] The query URL
    # @param result [Array] The response
    def http(url, result)
      request = HTTPI::Request.new(url)
      HTTPI.log = false
      request = HTTPI.get(request)
      if request.code == 200
        result = request.body
      else
        puts "HTTP Status #{request.code}"
        puts "HTTP Body #{request.body}"
      end
      return result
    end
  end
end
