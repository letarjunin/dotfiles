#!/usr/bin/env ruby

require 'washbullet'
require 'open-uri'
require 'shellwords'
require 'pry'
require_relative 'pb_private.rb'

HOME = File.expand_path( "~" )
TEMP_FILE = "#{ HOME }/Downloads/temp.jpeg"

module OS_ENUM
  LINUX = 0
  MAC   = 1
  WIN   = 2
end

module SET_TYPE
  WALLPAPER = 0
  SERVICE   = 1
end

def self.print_msg( msg )
  puts msg if $DEBUG
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
  print_msg( url )
  File.open( TEMP_FILE, "wb") do |saved_file|
    open( url, "rb" ) do |read_file|
      saved_file.write(read_file.read)
    end
  end
end

def get_image( set_type )
  #Note, you need your own API_KEY defined here.
  client = Washbullet::Client.new( API_KEY )
  pushes = client.get_pushes.body[ "pushes" ]
  if( pushes.length )
    if( SET_TYPE::SERVICE == set_type )
      pushes = pushes.slice( 0, 1 )
    end
    pushes.each do |p|
      if ( p[ "active" ].to_s == 'true' and 
          p[ 'type' ].to_s == 'file' and
          p[ 'file_type' ].to_s.include? ( 'image' ) )
        download_file( p[ 'file_url' ] )
        return true
      end
    end
  end
  return false
end

def set_wallpaper( set_type )
  cmd = ""
  if os_type == OS_ENUM::LINUX
    cmd = "gsettings set org.gnome.desktop.background picture-uri file:///#{ TEMP_FILE }" 
  elsif os_type == OS_ENUM::MAC
    cmd = "osascript -e 'tell application \"Finder\" to set desktop picture to POSIX file \"#{ TEMP_FILE }\"'; killall Dock"
  else
    return #WIN not supported yet!
  end

  `#{cmd}` if ( get_image( set_type ) )
end

def wrap_string( str )
  width = `tput cols`.to_i
  sarray = str.gsub(/\n/," ").scan(/\S.{0,#{width-4}}\S(?=\s|$)|\S+/)
  sarray.collect! { |s| s = " #{s}" }
  sarray.join "\n"
end

if __FILE__ == $0
  set_wallpaper( SET_TYPE::WALLPAPER )
end

# vim: set filetype=ruby:ts =4:sw=4
