#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'faye/websocket'
require 'eventmachine'
require 'pry'
require 'colorize'
require 'date'
require_relative 'pb_private.rb'
require_relative 'pb_wallpaper_api.rb'

WS_URL = 'https://stream.pushbullet.com/websocket/'

def wrap_string( str )
  width = `tput cols`.to_i
  sarray = str.gsub(/\n/," ").scan(/\S.{0,#{width-4}}\S(?=\s|$)|\S+/)
  sarray.collect! { |s| s = " #{s}" }
end

EM.run{
  ws = Faye::WebSocket::Client.new( WS_URL + API_KEY )

  ws.on :start do |event|
    puts wrap_string "Welcome to PB pushbullet."
  end

  puts
  ws.on :message do |event|
    j = JSON.parse(event.data)
    if( j["type"] == "tickle" and j["subtype"] == "push" )
      begin
        set_wallpaper( SET_TYPE::SERVICE )
      rescue Exception => e
        print_msg "set_wallpaper function errored with -'#{ e.message }'"
      end
    end

    if( j["type"] == "push" && j["push"]["type"] == "mirror" )
      puts wrap_string "#{ Time.now.strftime('%H:%M') } - #{ j["push"]["application_name"] } ".light_blue 
      puts wrap_string "#{ j["push"]["title"] }".yellow
      puts wrap_string j["push"]["body"]
      puts 
    end

  end

  ws.on :close do |event|
    print_msg "Websocket is clsoing.! #{ event.reason }"
  end
}
