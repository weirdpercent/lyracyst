# coding: utf-8
require 'rainbow'
module Lyracyst
  class Wolfram
    # Handles Wolfram's assumptions about your query.
    class Assume
      # @param assumptions [Hash] Hash of assumption data.
      def assume(assumptions)
        if assumptions['count'].to_i > 1
          puts Rainbow("FIXME: I don't handle arrays of assumptions.").red.bright
        else
          puts ''
          Lyracyst.label('Assumptions')
          a = assumptions['assumption']
          puts "Type: #{a['type']}"
          v = a['value']
          if v.class == Array
            x, y, vcont = 0, v.length - 1, []
            while x <= y
              value = v[x]
              Lyracyst.label("Assumption #{x + 1}")
              puts " - Name: #{value['name']}|Desc: #{value['desc']}|Input: #{value['input']}"
              x += 1
            end
          else
            value = v[0]
            Lyracyst.label('Assumption 1')
            puts " - Name: #{value['name']}|Desc: #{value['desc']}|Input: #{value['input']}"
          end
        end
      end
    end
  end
end
