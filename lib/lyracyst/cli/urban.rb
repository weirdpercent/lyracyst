desc 'Fetches definitions from Urban Dictionary'
arg_name 'word'
command :urb do |c|
  c.action do |global_options, options, args|
    search = args[0]
    ur = Lyracyst::Urban::Define.new
    ur.get_def(search)
  end
end
