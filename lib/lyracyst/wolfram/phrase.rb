# coding: utf-8
require 'httpi'

module Lyracyst
  # Wolfram|Alpha introduces a fundamentally new way to get knowledge
  # and answers -- not by searching the web, but by doing dynamic
  # computations based on a vast collection of built-in data,
  # algorithms, and methods.
  class Wolfram
    # Fetches dynamically generated URL.
    #
    # @param search [String] The word or phrase to search for.
    # @param params [Hash] The search parameters to use.
    def get_phrase(search, params)
      prefix = 'http://api.wolframalpha.com/v2/query?input='
      word, pcont = "#{prefix}#{search}", []
      params.map { |k, v|
        if k == :format then pcont.push "&format=#{v}"; end
        if k == :incpid then pcont.push "&includepodid=#{v}"; end
        if k == :excpid then pcont.push "&excludepodid=#{v}"; end
        if k == :podtitle then pcont.push "&podtitle=#{v}"; end
        if k == :podindex then pcont.push "&podindex=#{v}"; end
        if k == :scanner then pcont.push "&scanner=#{v}"; end
        if k == :async then pcont.push "&async=#{v}"; end
        if k == :lspec then pcont.push "&location%20specifications=#{v}"; end
        if k == :assumption then pcont.push "&assumption=#{v}"; end
        if k == :units then pcont.push "&units=#{v}"; end
        if k == :wspec then pcont.push "&width%20specifications=#{v}"; end
        if k == :sto then pcont.push "&scantimeout=#{v}"; end
        if k == :poto then pcont.push "&podtimeout=#{v}"; end
        if k == :fto then pcont.push "&formattimeout=#{v}"; end
        if k == :pato then pcont.push "&parsetimeout=#{v}"; end
        if k == :reinterpret then pcont.push "&reinterpret=#{v}"; end
        if k == :trans then pcont.push "&translation=#{v}"; end
        if k == :icase then pcont.push "&ignorecase=#{v}"; end
        if k == :sig then pcont.push "&sig=#{v}"; end
      }
      apikey = ENV['WOLFRAM']
      pcont.push "&appid=#{apikey}"
      url = "#{word}#{pcont.join}"
      request = HTTPI::Request.new(url)
      getter = HTTPI.get(request)
      result = getter.body
    end
  end
end
