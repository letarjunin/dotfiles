#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'faye/websocket'
require 'eventmachine'
require 'pry'
require_relative 'pb_private.rb'
require_relative 'pb_wallpaper_api.rb'

WS_URL = 'https://stream.pushbullet.com/websocket/'

EM.run{
  ws = Faye::WebSocket::Client.new( WS_URL + API_KEY )

  ws.on :message do |event|
    j = JSON.parse(event.data)
    if( j["type"] == "tickle" and j["subtype"] == "push" )
      begin
        set_wallpaper( SET_TYPE::SERVICE )
      rescue Exception => e
        print_msg "set_wallpaper function errored with -'#{ e.message }'"
      end
    end
  end

  ws.on :close do |event|
    print_msg "Websocket is clsoing.! #{ event.reason }"
  end
}
