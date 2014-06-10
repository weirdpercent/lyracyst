%w{httpi multi_xml rainbow}.map { |lib| require lib }
module Lyracyst
  # Fetches definitions, phrases, similar words, and resource links from Onelook
  class Onelook
    # @param search [String] The term to search for
    # @param search [String] The XML response
    def get_word(search, result)
      prefix = 'http://www.onelook.com/?xml=1&w='
      url = "#{prefix}#{search}"
      request = HTTPI::Request.new(url)
      getter = HTTPI.get(request)
      result = getter.body
    end
    # Fetches and processes URL
    class Fetch
      # Main operations. Resource links are off by default.
      #
      # @param search [String] The term to search for
      # @param source [Boolean] Whether to print resource links (verbose)
      def fetch(search, source)
        label, result = 'Onelook', nil
        Lyracyst.label(label)
        fe = Lyracyst::Onelook.new
        result = fe.get_word(search, result)
        result = MultiXml.parse(result)
        result = result['OLResponse']
        st = { 'searchterm' => search }
        Lyracyst.tofile(st)
        t = { 'type' => 'look' }
        Lyracyst.tofile(t)
        de, re, ph, si = result['OLQuickDef'], result['OLRes'], result['OLPhrases'].strip, result['OLSimilar'].strip
        de.map { |defi|
          Lyracyst.label('Definition')
          defi = defi.gsub(/&lt;i&gt;|&lt;\/i&gt;/, '')
          d = { 'definition' => defi.strip }
          Lyracyst.tofile(d)
          puts defi.strip
        }
        Lyracyst.label('Phrases')
        ph = ph.split(',')
        puts ph.join('|')
        p = { 'phrases' => ph.join(',') }
        Lyracyst.tofile(p)
        Lyracyst.label('Similar words')
        si = si.split(',')
        puts si.join('|')
        s = { 'similar' => si.join(',') }
        Lyracyst.tofile(s)
        if source
          fet = Lyracyst::Onelook::Fetch.new
          fet.get_src(re)
        end
      end
      # Get resource links.
      #
      # @param re [Array] Array of resource hashes
      def get_src(re)
        x, y = 0, re.length - 1
        while x <= y
          res = re[x]
          name = res['OLResName'].strip
          link = res['OLResLink'].strip
          hlink = res['OLResHomeLink'].strip
          Lyracyst.label('Resources')
          puts "#{name}|#{link}|#{hlink}"
          n = { 'name' => name }
          l = { 'link' => link }
          hl = { 'hlink' => hlink }
          Lyracyst.tofile(n)
          Lyracyst.tofile(l)
          Lyracyst.tofile(hl)
          x += 1
        end
      end
    end
  end
end
