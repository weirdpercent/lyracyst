desc 'Fetches definitions from Wolfram|Alpha'
arg_name 'phrase'
command :wolf do |c|
  c.flag :assu, :default_value => nil, :arg_name => 'string', :desc => "Specifies an assumption, such as the meaning of a word or the value of a formula variable. See the 'Assumptions' section for more details. Optional."
  c.flag :excpid, :default_value => nil, :arg_name => 'string', :desc => "Specifies a pod ID to exclude. You can specify more than one of these elements in the query. Pods with the given IDs will be excluded from the result. Optional."
  c.flag :format, :default_value => nil, :arg_name => 'string,csv', :desc => "The desired result format(s). Possible values are 'image,plaintext,minput,moutput,cell,mathml,imagemap,sound,wav' To request more than one format type, separate values with a comma. Optional; defaults to 'plaintext,image'."
  c.flag :fto, :default_value => nil, :arg_name => 'integer', :desc => "The number of seconds to allow Wolfram|Alpha to spend in the 'format' stage for the entire collection of pods. Optional; defaults to 8.0."
  c.flag :incpid, :default_value => nil, :arg_name => 'string',  :desc => 'Specifies a pod ID to include. You can specify more than one of these elements in the query. Only pods with the given IDs will be returned.'
  c.flag :lspec, :default_value => nil, :arg_name => 'ip,latlong,location', :desc => "Some Wolfram|Alpha computations take into account the caller's current location. By default, Wolfram|Alpha attempts to determine the caller's location from the IP address, but you can override this by specifying location information in one of three forms. See the 'Specifying Your Location' section for more details. Optional; defaults to determining location via the IP address of the caller."
  c.flag :pato, :default_value => nil, :arg_name => 'integer', :desc => "The number of seconds to allow Wolfram|Alpha to spend in the 'parsing' stage of processing. Optional; defaults to 5.0."
  c.flag :podindex, :default_value => nil, :arg_name => 'integer,csv', :desc => "Specifies the index of the pod(s) to return. This is an alternative to specifying pods by title or ID. You can give a single number or a sequence like '2,3,5'. Optional; default is all pods."
  c.flag :podtitle, :default_value => nil, :arg_name => 'string,csv', :desc => 'Specifies a pod title. You can specify more than one of these elements in the query. Only pods with the given titles will be returned. You can use * as a wildcard to match zero or more characters in pod titles. Optional.'
  c.flag :poto, :default_value => nil, :arg_name => 'integer', :desc => "The number of seconds to allow Wolfram|Alpha to spend in the 'format' stage for any one pod. Optional; defaults to 4.0."
  c.flag :scanner, :default_value => nil, :arg_name => 'string,csv', :desc => 'Specifies that only pods produced by the given scanner should be returned. You can specify more than one of these elements in the query. Optional; default is all pods.'
  c.flag :sig, :default_value => nil, :arg_name => 'string', :desc => 'A special signature that can be applied to guard against misuse of your AppID. Optional.'
  c.flag :sto, :default_value => nil, :arg_name => 'integer', :desc => "The number of seconds to allow Wolfram|Alpha to compute results in the 'scan' stage of processing. Optional; defaults to 3.0."
  c.flag :units, :default_value => nil, :arg_name => 'string', :desc => "Lets you specify the preferred measurement system, either 'metric' or 'nonmetric' (U.S. customary units). Optional; defaults to making a decision based on the caller's geographic location."
  c.flag :wspec, :default_value => nil, :arg_name => 'width,maxwidth,plotwidth,mag', :desc => "These specifications control the page width in pixels for which the output should be formatted. See the section 'Controlling the Width of Results' for more details. Optional. Default width and maxwidth are 500; default plotwidth is 200; default mag is 1.0."
  c.switch :fassu, :default_value => false, :desc => 'Fetches assumptions'
  c.switch :icase, :default_value => false, :desc => 'Whether to force Wolfram|Alpha to ignore case in queries. Optional.'
  c.switch :reint, :default_value => false, :desc => "Whether to allow Wolfram|Alpha to reinterpret queries that would otherwise not be understood. Optional."
  c.switch :trans, :default_value => true, :desc => "Whether to allow Wolfram|Alpha to try to translate simple queries into English. Optional."
  c.action do |global_options, options, args|
    if args.length > 1
      search = args.join(' ')
    else
      search = args[0]
    end
    params = { assu: options[:assu], excpid: options[:excpid], fassu: options[:fassu], format: options[:format], fto: options[:fto], icase: options[:icase], incpid: options[:incpid], lspec: options[:lspec], pato: options[:pato], podindex: options[:podindex], podtitle: options[:podtitle], poto: options[:poto], reint: options[:reint], scanner: options[:scanner], sig: options[:sig], sto: options[:sto], trans: options[:trans], units: options[:units], wspec: options[:wspec] }
    wol = Lyracyst::Wolfram::Fetch.new
    wol.fetch(search, params)
  end
end
