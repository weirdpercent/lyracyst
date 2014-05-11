# coding: utf-8

module Lyracyst
  #The Get class defines a method to search all sources.
  class Get
    # Get searches each source with the same query.
    #
    # @param search [String] The word to search for.
    # @param result [Array] The response array.
    # @param lang [String] The search language.
    # @param fmt [String] The response format, json or xml.
    def get(search, result, lang, fmt)
      de = Lyracyst::Define.new
      re = Lyracyst::Relate.new
      rh = Lyracyst::Rhyme.new
      de.define(search, fmt)
      re.relate(search, result, lang, fmt)
      result = []
      rh.rhyme(search, result)
    end
  end
end
