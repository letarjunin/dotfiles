#!/usr/bin/env ruby

require 'washbullet'                                                     
require 'open-uri'
require 'shellwords'
require 'pry'
require_relative 'pb_private.rb'

TEMP_FILE = "/tmp/temp.jpeg"

def download_file( url, folder = TEMP_FILE )
  File.open( TEMP_FILE, "wb") do |saved_file|
    open( url, "rb" ) do |read_file|
      saved_file.write(read_file.read)
    end
  end
end

def process_pushes
    #Note, you need your own API_KEY defined here.
    client = Washbullet::Client.new( API_KEY )
    client.pushes.body[ "pushes" ].each do |p|
      if p[ "active" ].to_s == 'true' and p[ 'type' ].to_s == 'file' and p[ 'direction' ].to_s == 'self' and p[ 'file_type' ].to_s.include? ( 'image/jpeg' )
        download_file( p[ 'image_url' ] )
        return true
      end
    end
    return false
end

def set_wallpaper
  cmd = ""
  if RUBY_PLATFORM.include? ("linux")
    cmd = "gsettings set org.gnome.desktop.background picture-uri file:///#{ TEMP_FILE }" 
  elsif RUBY_PLATFORM.include? ("darwin")
    cmd = "gsettings set org.gnome.desktop.background picture-uri file:///#{ TEMP_FILE }" 
  end
  exec cmd if process_pushes
end

set_wallpaper

