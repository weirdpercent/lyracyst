# coding: utf-8
require 'rainbow'
require 'wordnik'

module Lyracyst
  # The Wordnik class defines methods for interacting with The
  # Wordnik API.
  class Define
    # Wordnik.com's service provides definitions. The logger
    # defaults to Rails.logger or Logger.new(STDOUT). Set to
    # Logger.new('/dev/null') to disable logging.
    #
    # @param search [String] The word or phrase to search for.
    # @param fmt [String] The response format, json or xml.
    def define(search, fmt)
      apikey = ENV['WORDNIK']
      Wordnik.configure do |cfg|
        cfg.api_key = apikey
        cfg.response_format = fmt
        cfg.logger = Logger.new('/dev/null')
      end
      defi = Wordnik.word.get_definitions(search)
      if defi != ''
        defi.map { |d|
          text = d['text']
          # att = d['attributionText']
          part = d['partOfSpeech']
          print Rainbow("[").blue.bright
          print Rainbow("Definition").green.bright
          print Rainbow("]").blue.bright
          print Rainbow("#{part} - ").bright
          puts "#{text}"
          # puts "Definition: #{part} - #{text} - #{att}" # With attribution
        }
      else
        puts 'Wordnik returned an empty string.'
      end
    end
  end
end
