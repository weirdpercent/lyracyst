desc 'Fetches word info from Onelook'
arg_name 'word'
command :look do |c|
  c.switch :source, :default_value => false, :desc => 'Fetches resource links (verbose)'
  c.action do |global_options, options, args|
    search = args[0]
    source = options[:source]
    fe = Lyracyst::Onelook::Fetch.new
    fe.fetch(search, source)
  end
end
