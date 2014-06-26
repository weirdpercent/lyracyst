desc 'Fetches anagrams from Wordsmith'
arg_name 'word'
command :ana do |c|
  c.flag :lang, :default_value => 'english', :arg_name => 'string', :desc => 'english,english-obscure,german,spanish,esperanto,french,italian,latin,dutch,portuguese,swedish,names'
  c.flag :limit, :default_value => 10, :arg_name => 'integer', :desc => 'Limits number of results returned'
  c.flag :maxwords, :default_value => nil, :arg_name => 'integer', :desc => 'Maximum number of words in each anagram'
  c.flag :include, :default_value => nil, :arg_name => 'string', :desc => 'Anagrams must include this word'
  c.flag :exclude, :default_value => nil, :arg_name => 'string', :desc => 'Anagrams must exclude these words'
  c.flag :minletters, :default_value => nil, :arg_name => 'integer', :desc => 'Minimum number of letters in each word'
  c.flag :maxletters, :default_value => nil, :arg_name => 'integer', :desc => 'Maximum number of letters in each word'
  c.flag :case, :default_value => 1, :arg_name => 'integer', :desc => '0 - Lowercase, 1 - First Letter, 2 - Uppercase'
  c.switch :repeat, :default_value => false, :desc => 'Repeat occurrences of a word OK'
  c.switch :list, :default_value => false, :desc => 'Show candidate word list only'
  c.switch :linenum, :default_value => false, :desc => 'Show line numbers with anagrams'
  c.action do |global_options, options, args|
    search = args[0]
    if options[:repeat] == true
      repeat = 'y'
    else
      repeat = 'n'
    end
    if options[:list] == true
      list = 'y'
    else
      list = 'n'
    end
    if options[:linenum] == true
      linenum = 'y'
    else
      linenum = 'n'
    end
    params = { lang: options[:lang], limit: options[:limit], maxwords: options[:maxwords], include: options[:include], exclude: options[:exclude], minletters: options[:minletters], maxletters: options[:maxletters],  case: options[:case], repeat: repeat, list: list, linenum: linenum }
    result = nil
    ana = Lyracyst::Wordsmith.new
    ana.scrape(search, params, result)
  end
end
