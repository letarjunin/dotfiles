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
E_PATH = "v2/ephemerals"

@json_obj = Array.new

Thread.new{
  EM.run{
    ws = Faye::WebSocket::Client.new( WS_URL + API_KEY )

    ws.on :open do |event|
      puts wrap_string "Happy Mirroring!.".green
      puts
    end

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
        @json_obj.push j
        puts wrap_string "#{ Time.now.strftime('%H:%M') } - #{ j["push"]["application_name"] } ".light_blue 
        puts wrap_string "#{ j["push"]["title"] }".yellow
        puts wrap_string j["push"]["body"]
        puts 
      end

    end

    ws.on :close do |event|
      print_msg "Websocket is closing.! #{ event.reason }"
    end
  }
}

def send_reply_msg( json )
  if( json["type"] == "push" && json["push"]["package_name"] == "com.whatsapp" )
    print wrap_string "Replying to #{ json["push"]["title"] }. - ".green
    reply = gets
    if not( reply )
      puts "Ignoring reply (empty message)".red
      return
    end

    payload = {
      "type": "push",
      "push": {
        "type": "messaging_extension_reply",
        "package_name": "com.whatsapp",
        "source_user_iden": json["push"]["source_user_iden"],
        "target_device_iden": json["push"]["source_device_iden"],
        "conversation_iden": json["push"]["conversation_iden"],
        "message": reply
      }
    }.to_json

    client = Washbullet::Client.new(API_KEY)
    client.post( E_PATH, payload )
  else 
    puts wrap_string "Error: Can only reply to WhatApp and TextMessage.".red 
  end
end

while(true)
  temp = gets.chomp
  if( temp.start_with?"r " )
    reply_to = temp.split(" ")[1].to_i
    j_size = @json_obj.size
    if( j_size >= reply_to  )
      send_reply_msg( @json_obj[ j_size - 1 - reply_to ] )
    else
      puts wrap_string "Error: Message (#{reply_to}) does not exist.".red
    end
  else 
    puts wrap_string "Use: r <int> to respond to WhatsApp messages".red
  end
end
