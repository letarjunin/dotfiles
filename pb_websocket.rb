#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'faye/websocket'
require 'eventmachine'
require 'pry'
require_relative 'pb_private.rb'
require_relative 'pb_wallpaper_api.rb'

WS_URL = 'https://stream.pushbullet.com/websocket/'

DEBUG=true

def print_msg( msg )
  puts msg if DEBUG
end

EM.run{
  time_now = Time.now.to_i
  ws = Faye::WebSocket::Client.new( WS_URL + API_KEY )

  ws.on :message do |event|
    j = JSON.parse(event.data)
    if( j["type"] == "nop" )
      time_now = Time.now.to_i
    end
    if( j["type"] == "tickle" and j["subtype"] == "push" )
      begin
        set_wallpaper( time_now )
      rescue Exception => e
        print_msg "set_wallpaper function errored with -'#{ e.message }'"
      end
    end
  end

  ws.on :close do |event|
    print_msg "Websocket is clsoing.! #{ event.reason }"
  end
}
