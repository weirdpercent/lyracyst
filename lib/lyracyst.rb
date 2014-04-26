#!/usr/bin/env ruby

require 'commander/import'
require './lib/lyracyst/fetch.rb'
require './lib/lyracyst/search.rb'
require './lib/lyracyst/version.rb'

# The program takes a search term and returns a list.
# The list can be either definitions, related words,
# rhymes, or all three at once.
#
# Author::    Drew Prentice  (mailto:weirdpercent@gmail.com)
# Copyright:: Copyright (c) 2014 Drew Prentice
# License::   MIT
module Lyracyst
  environment = 'ruby'
  program :name, 'lyracyst'
  program :version, VERSION
  program :description, 'A powerful word search tool that fetches definitions, related words, and rhymes.'

  command :get do |c|
    c.syntax = 'lyracyst get word'
    c.summary = 'Fetches all sources'
    c.description = 'Searches definitions, related words, and rhymes for a given query'
    c.example 'Fetches info about the word test', 'lyracyst get test'
    #c.option = '--lang en_US', String, 'Sets search language'
    #c.option = '--fmt json', String, 'Sets XML or JSON format'
    c.action do |args, options|
      #options.default :lang => 'en_US', :fmt => 'json'
      lang = 'en_US'
      fmt = 'json'
      search = args[0]
      fmt = 'json'
      result = []
      s = Lyracyst::Search.new
      puts "Getting all for [#{search}]"
      s.define(search)
      s.related(search, result, lang, fmt)
      s.rhyme(search, result)
    end
  end

  command :define do |c|
    c.syntax = 'lyracyst define word'
    c.summary = 'Fetches definitions'
    c.description = 'Uses the Wordnik API to get definitions'
    c.example 'Uses the Wordnik API to get definitions of the word test', 'lyracyst define test'
    c.action do |args, options|
      search = args[0]
      s = Lyracyst::Search.new
      puts "Getting definitions for [#{search}]"
      s.define(search)
    end
  end

  command :related do |c|
    c.syntax = 'lyracyst related word'
    c.summary = 'Fetches related words'
    c.description = 'Uses the Altervista API to get related words'
    c.example 'Uses the Altervista API to get words related to test', 'lyracyst related test'
    #c.option = '--lang', String, 'Sets search language'
    c.action do |args, options|
      lang = 'en_US'
      fmt = 'json'
      search = args[0]
      result = []
      s = Lyracyst::Search.new
      puts "Getting related words for [#{search}]"
      s.related(search, result, lang, fmt)
    end
  end

  command :rhyme do |c|
    c.syntax = 'lyracyst rhyme word'
    c.summary = 'Fetches rhymes'
    c.description = 'Uses the ARPABET system to get rhymes'
    c.example 'Uses the ARPABET system to get rhymes with test', 'lyracyst rhyme test'
    c.option '--some-switch', 'Some switch that does something'
    c.action do |args, options|
      result = []
      search = args[0]
      s = Lyracyst::Search.new
      puts "Getting rhymes for [#{search}]"
      s.rhyme(search, result)
    end
  end
end
