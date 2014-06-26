# coding: utf-8
require 'metainspector'

module Lyracyst
  # Wordsmith.org provides anagrams.
  class Wordsmith
    # The scraper method.
    #
    # @param search [String] The string of letters to rearrange.
    # @param params [Hash] The search parameters to use.
    # @param result [Hash] The search results.
    def scrape(search, params, result)
      prefix = 'http://wordsmith.org/anagram/anagram.cgi?anagram='
      word, pcont = "#{prefix}#{search}", []
      params.map { |k, v|
        if k == :lang then pcont.push "&language=#{v}"; end # string
        if k == :limit then pcont.push "&t=#{v}"; end # integer
        if k == :maxwords then pcont.push "&d=#{v}"; end # integer
        if k == :include then pcont.push "&include=#{v}"; end # string
        if k == :exclude then pcont.push "&exclude=#{v}"; end # string
        if k == :minletters then pcont.push "&n=#{v}"; end # integer
        if k == :maxletters then pcont.push "&m=#{v}"; end # integer
        if k == :repeat then pcont.push "&a=#{v}"; end # y/n
        if k == :list then pcont.push "&l=#{v}"; end # y/n
        if k == :linenum then pcont.push "&q=#{v}"; end # y/n
        if k == :case then pcont.push "&k=#{v}"; end # 0 - lower, 1 - first, 2 - upper
      }
      pcont.push "&src=adv"
      url = "#{word}#{pcont.join}"
      result = MetaInspector.new(url)
      pdoc = result.parsed
      text = pdoc.at_css('p:nth-child(7)').text
      s = text.scan(/^\s(\d*) found. Displaying ([a-z0-9 ]*):([a-z\s]*)What's/i)
      s = s[0]
      found = s[0]
      display = s[1]
      astring = s[2]
      search = { 'search' => search }
      anagrams = { 'anagrams' => astring }
      Lyracyst.tofile(search)
      Lyracyst.tofile(anagrams)
      Lyracyst.label('Anagrams')
      puts "Found #{found}. Displaying #{display}:\n#{astring}"
    end
  end
end
