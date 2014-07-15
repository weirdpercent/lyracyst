# coding: utf-8
module Lyracyst
  class Wolfram
    # Handles all pod and subpod operations.
    class Pod
      # The main pod handler.This method calls
      # {Lyracyst::Wolfram::Pod#numsubpods}.
      #
      # @param pods [Array] List of hashes to process.
      def pod(pods)
        x, y, pcont = 0, pods.length - 1, []
        while x <= y
          p = pods[x]
          Lyracyst.label("Pod #{x + 1}")
          Lyracyst.label('Pod Title')
          print "#{p['title']}"
          Lyracyst.label('Pod Text')
          print "#{p['plaintext']}"
          Lyracyst.label('Pod Error')
          print "#{p['error']}"
          Lyracyst.label('Pod Scanner')
          print "#{p['scanner']}"
          Lyracyst.label('Subpod Count')
          print "#{p['numsubpods']}"
          Lyracyst.label('Pod Position')
          print "#{p['position']}"
          sp = p['subpod']
          nsp = Lyracyst::Wolfram::Pod.new
          nsp.numsubpods(p, sp)
          x += 1
        end
      end
      # The main subpod handler.
      #
      # @param subpods [Array] List of hashes to process.
      def subpod(subpods)
        x, y, pcont = 0, subpods.length - 1, []
        while x <= y
          sp = subpods[x]
          img = sp['img']
          Lyracyst.label("Subpod #{x + 1}")
          Lyracyst.label('Subpod Title')
          print "#{sp['title']}"
          Lyracyst.label('Subpod Text')
          print "#{sp['plaintext']}"
          Lyracyst.label('Subpod Image')
          puts "#{img['src']}"
          x += 1
        end
      end
      # Single/Multiple pod switch. This method calls
      # {Lyracyst::Wolfram::Pod#pod} and
      # {Lyracyst::Wolfram::Pod#numsubpods}.
      #
      # @param p [Hash] The pod to process.
      # @param np [Integer] The number of pods.
      def numpods(p, np)
        if np > 1
          pod = Lyracyst::Wolfram::Pod.new
          pod.pod(p)
        else
          Lyracyst.label('Pod 1')
          Lyracyst.label('Pod Title')
          print "#{p['title']}"
          Lyracyst.label('Pod Text')
          print "#{p['plaintext']}"
          Lyracyst.label('Pod Error')
          print "#{p['error']}"
          Lyracyst.label('Pod Scanner')
          print "#{p['scanner']}"
          Lyracyst.label('Subpod Count')
          print "#{p['numsubpods']}"
          Lyracyst.label('Pod Position')
          puts "#{p['position']}"
          sp = p['subpod']
          nsp = Lyracyst::Wolfram::Pod.new
          nsp.numsubpods(p, sp)
        end
      end
      # Single/Multiple subpod switch. This method calls
      # {Lyracyst::Wolfram::Pod#subpod}.
      #
      # @param p [Hash] The pod to process.
      # @param sp [Hash] The subpod to process.
      def numsubpods(p, sp)
        if p['numsubpods'].to_i > 1
          sub = Lyracyst::Wolfram::Pod.new
          sub.subpod(sp)
        else
          img = sp['img']
          Lyracyst.label('Subpod 1')
          Lyracyst.label('Subpod Title')
          print "#{sp['title']}"
          Lyracyst.label('Subpod Text')
          print "#{sp['plaintext']}"
          Lyracyst.label('Subpod Image')
          puts "#{img['src']}"
        end
      end
    end
  end
end
