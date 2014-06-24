desc 'Rhymebrain operations'
command :rb do |rb|
  rb.flag :lang, :default_value => 'en', :arg_name => 'string', :desc => 'ISO639-1 language code (optional). Eg. en, de, es, fr, ru'
  rb.flag :max, :default_value => nil, :arg_name => 'integer', :desc => '(optional) The number of results to return. If you do not include this parameter, RhymeBrain will choose how many words to show based on how many good sounding rhymes there are for the word.'
  rb.desc 'Fetches rhymes from Rhymebrain.com'
  rb.arg_name 'word'
  rb.command :rhy do |rhyme|
    rhyme.action do |global_options, options, args|
      search = args[0]
      params = { lang: options[:lang], max: options[:max] }
      rhym = Lyracyst::Rhymebrain::Rhyme.new
      rhym.get_rhyme(search, params)
    end
  end
  rb.desc 'Fetches word info from Rhymebrain.com'
  rb.arg_name 'word'
  rb.command :inf do |info|
    info.action do |global_options, options, args|
      search = args[0]
      params = { lang: options[:lang], max: options[:max] }
      info = Lyracyst::Rhymebrain::Info.new
      info.get_info(search, params)
    end
  end
  rb.desc 'Fetches combined words (portmanteaus) from Rhymebrain.com'
  rb.arg_name 'word'
  rb.command :comb do |combine|
    combine.action do |global_options, options, args|
      search = args[0]
      params = { lang: options[:lang], max: options[:max] }
      port = Lyracyst::Rhymebrain::Combine.new
      port.get_port(search, params)
    end
  end
end
