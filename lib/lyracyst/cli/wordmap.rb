desc 'Map word info'
arg_name 'word'
command :wmap do |map|
	map.action do |global_options, options, args|
		search = args[0]
		system "lyracyst wn def #{search}"
		system "lyracyst wn ex #{search}"
		system "lyracyst wn hyph #{search}"
		system "lyracyst wn ori #{search}"
		system "lyracyst wn phr #{search}"
		system "lyracyst wn pro #{search}"
		system "lyracyst wn rel #{search}"
		system "lyracyst rb comb #{search}"
		system "lyracyst rb inf #{search}"
		system "lyracyst rb rhy #{search}"
		system "lyracyst urb #{search}"
		system "lyracyst ana #{search}"
	end
end
