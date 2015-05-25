#!/usr/bin/env ruby

require 'washbullet'                                                     
require 'open-uri'
require 'shellwords'
require 'pry'
require_relative 'pb_private.rb'

PWD = Dir.pwd
TEMP_FILE = "#{ PWD }/Downloads/temp.jpeg"

module OS_ENUM
  LINUX = 0
  MAC   = 1
  WIN   = 2
end

def os_type
  if RUBY_PLATFORM.include? ("linux")
    return OS_ENUM::LINUX
  elsif RUBY_PLATFORM.include? ("darwin")
    return OS_ENUM::MAC
  else
    return OS_ENUM::WIN
  end
end

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
      if p[ "active" ].to_s == 'true' and p[ 'type' ].to_s == 'file' and p[ 'file_type' ].to_s.include? ( 'image/jpeg' )
        download_file( p[ 'image_url' ] )
        return true
      end
    end
    return false
end

def set_wallpaper
  cmd = ""
  if os_type == OS_ENUM::LINUX
    cmd = "gsettings set org.gnome.desktop.background picture-uri file:///#{ TEMP_FILE }" 
  elsif os_type == OS_ENUM::MAC
    cmd = "osascript -e 'tell application \"Finder\" to set desktop picture to POSIX file \"#{ TEMP_FILE }\"'; killall Dock"
  else
    return #WIN not supported yet!
  end
  exec cmd if process_pushes
end

set_wallpaper
