desc 'Wordnik operations'
command :wn do |nik|
  nik.switch :canon, :default_value => false, :desc => 'Use canonical', :long_desc => "If true will try to return the correct word root ('cats' -> 'cat'). If false returns exactly what was requested."
  nik.flag :limit, :default_value => 5, :arg_name => 'integer', :desc => 'Maximum number of results to return'
  nik.desc 'Fetch definitions from Wordnik'
  nik.arg_name 'word'
  nik.command :def do |define|
    define.flag :defdict, :default_value => 'all', :arg_name => 'string', :desc => "CSV list. Source dictionaries to return definitions from. If 'all' is received, results are returned from all sources. If multiple values are received (e.g. 'century,wiktionary'), results are returned from the first specified dictionary that has definitions. If left blank, results are returned from the first dictionary that has definitions. By default, dictionaries are searched in this order: ahd, wiktionary, webster, century, wordnet"
    define.flag [:p, :part], :default_value => nil, :arg_name => 'csv', :desc => 'Comma-separated list of parts of speech. See http://developer.wordnik.com/docs.html#!/word/getDefinitions_get_2 for list of parts.'
    define.action do |global_options, options, args|
      search = args[0]
      params = { canon: options[:canon], defdict: options[:defdict], increl: false, inctags: false, limit: options[:limit] }
      df = Lyracyst::Wordnik::Define.new
      df.get_def(search, options[:p], params)
    end
  end
  nik.desc 'Fetch examples from Wordnik'
  nik.arg_name 'word'
  nik.command :ex do |example|
    example.flag [:s, :skip], :default_value => 0, :arg_name => 'integer', :desc => 'Results to skip'
    example.switch :incdups, :default_value => false, :desc => 'Show duplicate examples from different sources'
    example.action do |global_options, options, args|
      search = args[0]
      params = { canon: options[:canon], incdups: options[:incdups], limit: options[:limit], skip: options[:s] }
      ex = Lyracyst::Wordnik::Example.new
      ex.get_ex(search, params)
    end
  end
  nik.desc 'Fetches related words from Wordnik'
  nik.arg_name 'word'
  nik.command :rel do |relate|
    relate.flag :relt, :default_value => nil, :arg_name => 'integer', :desc => 'Limits the total results per type of relationship type'
    relate.flag :rell, :default_value => 10, :arg_name => 'integer', :desc => 'Restrict to the supplied relationship types'
    relate.action do |global_options, options, args|
      search = args[0]
      params = { canon: options[:canon], rellimit: options[:rell] }
			rel = Lyracyst::Wordnik::Relate.new
			rel.get_rel(search, params, options[:relt])
    end
  end
  nik.desc 'Fetches pronunciations from Wordnik'
  nik.arg_name 'word'
  nik.command :pro do |pronounce|
    pronounce.flag :src, :default_value => nil, :arg_name => 'string', :desc =>'Get from a single dictionary. Valid options: ahd, century, cmu, macmillan, wiktionary, webster, or wordnet'
    pronounce.flag :pt, :default_value => nil, :arg_name => 'string', :desc => 'Text pronunciation type', :long_desc => 'ahd, arpabet, gcide-diacritical, IPA'
    pronounce.action do |global_options, options, args|
      search = args[0]
      params = { canon: options[:canon], limit: options[:limit], source: options[:src] }
      pr = Lyracyst::Wordnik::Pronounce.new
      pr.get_pro(search, params, options[:pt])
    end
  end
  nik.desc 'Fetches hyphenation and syllable stresses from Wordnik. Primary stress is red, secondary stress is bright white.'
  nik.arg_name 'word'
  nik.command :hyph do |hyphen|
    hyphen.flag :source, :default_value => nil, :arg_name => 'string', :desc => "Get from a single dictionary. Valid options: ahd, century, wiktionary, webster, and wordnet."
    hyphen.action do |global_options, options, args|
      search = args[0]
      params = { canon: options[:canon], limit: options[:limit] }
      if options[:source] != nil then params[:source] = options[:source]; end
      hyph = Lyracyst::Wordnik::Hyphen.new
      hyph.get_hyph(search, params)
    end
  end
  nik.desc 'Fetches bi-gram phrases from Wordnik'
  nik.arg_name 'word'
  nik.command :phr do |phrase|
    phrase.flag :wlmi, :default_value => 13, :arg_name => 'integer', :desc => 'Minimum WLMI(weighted mutual info) for the phrase.'
    phrase.action do |global_options, options, args|
      search = args[0]
      params = { canon: options[:canon], limit: options[:limit], wlmi: options[:wlmi] }
      phra = Lyracyst::Wordnik::Phrase.new
      phra.get_phr(search, params)
    end
  end
  nik.desc 'Fetches etymologies from Wordnik'
  nik.arg_name 'word'
  nik.command :ori do |origin|
    origin.action do |global_options, options, args|
      search = args[0]
      params = { canon: options[:canon] }
      orig = Lyracyst::Wordnik::Origin.new
      orig.get_et(search, params)
    end
  end
end
