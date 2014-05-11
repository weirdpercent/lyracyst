#!/usr/bin/env ruby
# coding: utf-8

require 'commander/import'
require 'rainbow'
require './lib/lyracyst/define.rb'
require './lib/lyracyst/get.rb'
require './lib/lyracyst/relate.rb'
require './lib/lyracyst/rhyme.rb'
require './lib/lyracyst/version.rb'

# The program takes a search term and returns a list.
# The list can be either definitions, related words,
# rhymes, or all three at once.
#
# Author::    Drew Prentice  (mailto:weirdpercent@gmail.com)
# Copyright:: Copyright (c) 2014 Drew Prentice
# License::   MIT
module Lyracyst
  # The platform this app is running on. For now only Ruby, plans for node.js version in the future.
  ENVIRONMENT = 'ruby'
  program :name, 'lyracyst'
  program :version, VERSION
  program :description, 'A powerful word search tool that fetches definitions, related words, and rhymes.'

  command :get do |c|
    c.syntax = 'lyracyst get word'
    c.summary = 'Fetches all sources'
    c.description = 'Searches definitions, related words, and rhymes for a given query'
    c.example 'Fetches info about the word test', 'lyracyst get test'
    c.option '--lang en_US', String, 'Sets search language'
    c.option '--fmt json', String, 'Sets XML or JSON format'
    c.action do |args, options|
      options.default :lang => 'en_US', :fmt => 'json'
      lang = options.lang
      fmt = options.fmt
      search = args[0]
      result = []
      g = Lyracyst::Get.new
      print Rainbow("Getting all for ").bright
      print Rainbow("[").blue.bright
      print Rainbow("#{search}").green.bright
      puts Rainbow("]").blue.bright
      g.get(search, result, lang, fmt)
    end
  end

  command :define do |c|
    c.syntax = 'lyracyst define word'
    c.summary = 'Fetches definitions'
    c.description = 'Uses the Wordnik API to get definitions'
    c.example 'Uses the Wordnik API to get definitions of the word test', 'lyracyst define test'
    c.option '--fmt json', String, 'Sets XML or JSON format'
    c.action do |args, options|
      options.default :fmt => 'json'
      fmt = options.fmt
      search = args[0]
      de = Lyracyst::Define.new
      print Rainbow("Getting definitions for ").bright
      print Rainbow("[").blue.bright
      print Rainbow("#{search}").green.bright
      puts Rainbow("]").blue.bright
      de.define(search, fmt)
    end
  end

  command :relate do |c|
    c.syntax = 'lyracyst relate word'
    c.summary = 'Fetches relate words'
    c.description = 'Uses the Altervista API to get related words'
    c.example 'Uses the Altervista API to get words related to test', 'lyracyst relate test'
    c.option '--lang en_US', String, 'Sets search language'
    c.option '--fmt json', String, 'Sets XML or JSON format'
    c.action do |args, options|
      options.default :lang => 'en_US', :fmt => 'json'
      lang = options.lang
      fmt = options.fmt
      search = args[0]
      result = []
      re = Lyracyst::Relate.new
      print Rainbow("Getting related words for ").bright
      print Rainbow("[").blue.bright
      print Rainbow("#{search}").green.bright
      puts Rainbow("]").blue.bright
      re.relate(search, result, lang, fmt)
    end
  end

  command :rhyme do |c|
    c.syntax = 'lyracyst rhyme word'
    c.summary = 'Fetches rhymes'
    c.description = 'Uses the ARPABET system to get rhymes'
    c.example 'Uses the ARPABET system to get rhymes with test', 'lyracyst rhyme test'
    c.action do |args|
      result = []
      search = args[0]
      rh = Lyracyst::Rhyme.new
      print Rainbow("Getting rhymes for ").bright
      print Rainbow("[").blue.bright
      print Rainbow("#{search}").green.bright
      puts Rainbow("]").blue.bright
      rh.rhyme(search, result)
    end
  end
end
