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

class Message

  def self.getsMsg()
    msg = gets.chomp
    if not( msg )
      puts wrap_string "Input cannot be empty. Aborting.".red
    end
    return msg
  end

  def self.sendWhatsAppReply( json  )
    return if not validateWhatsApp( json )
    reply = getsMsg()
    if ( reply )
      print wrap_string "Replying to #{ json["push"]["title"] }. - ".green
      payload = createPayloadJSON( json )
      payload[:push][:conversation_iden] = json["push"]["conversation_iden"]
      payload[:push][:message] = "#{reply}"
      sendMessage( payload.to_json )
    end
  end

  def self.sendWhatsAppMessage()
    print wrap_string "Input WhatsApp Number : ".green
    number  = getsMsg().to_i
    if( number )
      print wrap_string "Input Message to send : ".green
      msg = getsMsg()
      if ( msg )
        payload = createPayloadJSON()
        payload[:push][:conversation_iden] = { "package_name": "com.whatsapp", "tag": "#{ number }@s.whatsapp.net", "id":1 }
        payload[:push][:message] = "#{msg}"
        sendMessage( payload.to_json )
      end
    end
  end

  def self.sendSMS( number )
  end

  def self.validateWhatsApp(json)
    if( json["type"] == "push" && json["push"]["package_name"] == "com.whatsapp" )
      return true
    end
    return false
  end

  private
  def self.sendMessage( payload )
    client = Washbullet::Client.new(API_KEY)
    client.post( E_PATH, payload )
  end

  def self.createPayloadJSON( reply_json=nil)
    {
      "type": "push",
      "push": {
        "type": "messaging_extension_reply",
        "package_name": reply_json ? reply_json["push"]["package_name"] : "com.whatsapp",
        "source_user_iden": reply_json ? reply_json["push"]["source_user_iden"] : "ujA1IIOL2LA",
        "target_device_iden": reply_json ? reply_json["push"]["source_device_iden"] : "ujA1IIOL2LAsjzZuK9JmHA",
      }
    }
  end
end

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

def processInputString(temp)
  if( temp.start_with?"r " )
    j_size = @json_obj.size
    reply_to = temp.split(" ")[1].to_i
    if( j_size >= reply_to  )
      json = @json_obj[ j_size - 1 - reply_to ]
      Message.sendWhatsAppReply( json )
    else
      puts wrap_string "Error: Message (#{reply_to}) does not exist.".red
    end
    return
  end
  if( temp == "s" )
      Message.sendWhatsAppMessage()
      return
  end
  puts wrap_string "Use: r <int> or s <number> to respond/create WhatsApp messages".red
end

while(true)
  processInputString( gets.chomp )
end
