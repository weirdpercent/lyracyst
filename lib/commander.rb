require 'commander/import'
program :name, 'lyracyst'
program :version, '0.0.1'
program :description, 'A powerful word search tool that fetches definitions, related words, and rhymes.'
command :get do |c|
  c.syntax = 'lyracyst get [options]'
  c.summary = 'Fetches all sources'
  c.description = 'Searches definitions, related words, and rhymes for a given query'
  c.example 'Searches definitions, related words, and rhymes for a given query', 'lyracyst get test'
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.define(search)
    s.related(search, result)
    s.rhyme(search)
  end
end

command :define do |c|
  c.syntax = 'lyracyst define [options]'
  c.summary = 'Fetches definitions'
  c.description = 'Uses the Wordnik API to get definitions'
  c.example 'Uses the Wordnik API to get definitions', 'lyracyst define test'
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.define(search)
  end
end

command :related do |c|
  c.syntax = 'lyracyst related [options]'
  c.summary = 'Fetches related words'
  c.description = 'Uses the Altervista API to get related words'
  c.example 'Uses the Altervista API to get related words', 'lyracyst related test'
  #c.option '--some-switch', 'Some switch that does something' # it_IT, fr_FR, de_DE, en_US, el_GR, es_ES, de_DE, no_NO, pt_PT, ro_RO, ru_RU, sk_SK
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.related(search)
  end
end

command :rhyme do |c|
  c.syntax = 'lyracyst rhyme [options]'
  c.summary = 'Fetches rhymes'
  c.description = 'Uses the ARPABET system to get rhymes'
  c.example 'Uses the ARPABET system to get rhymes', 'lyracyst rhyme test'
  c.action do |args, options|
    search=args[0]
    s=Search.new
    puts "Searching for [#{search}]:"
    s.rhyme(search)
  end
end
