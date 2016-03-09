#!/usr/bin/env ruby

require 'washbullet'
require 'shellwords'
require_relative 'pb_private.rb'

def bash( cmd, bk )
    return unless cmd
    esc_cmd = Shellwords.escape( cmd )
    if bk
        system "bash -c #{ esc_cmd } > out.log 2>&1"
    else
        system "bash -c #{ esc_cmd }"
    end
end

def pb_exec( cmd )
    #Note, you need your own API_KEY defined here.
    client = Washbullet::Client.new( API_KEY )
    subject = "Execution Complete"
    body =  "Executed - #{ cmd  } \n"
    body << "Path     - #{ `pwd` }"
    #If you need to push to only 1 device, then you also need a device ID.
    client.push_note(
      receiver:   :client, # :email, :channel, :client
      identifier: '',
      params: {
        title: subject,
        body:  body
      }

    )
end

def exec( cmd, bk=false )
    bash( cmd, bk  )
    pb_exec( cmd )
end

def main
    bk = ARGV.size > 0 && ARGV[0] == "-b" ? true : false
    ARGV.shift if bk
    cmd = ARGV.join " "

    if bk
        job1 = fork do
            exec( cmd, bk )
        end
        Process.detach( job1 )
    else
        exec( cmd )
    end
end

if __FILE__ == $0
  main
end
