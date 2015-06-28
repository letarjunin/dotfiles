#!/usr/bin/env ruby

#require File.join(File.dirname(__FILE__),'lib','mplayer-ruby')
require 'mplayer-ruby'
require 'io/console'
require 'fileutils'
require 'timeout'
require 'pry'

MOVE_DIR_PATH = File.join( File.expand_path( "..", Dir.pwd ) , 'keep' )
TIMEOUT_VAL = 2
TIMEOUT_SONG_END_CHECK = 5
SHOW_DEBUG = false
$remain = 0

def print_output( o )
    puts o if SHOW_DEBUG
end

class MplayerWrapper
    def initialize( file )
        `pkill mplayer`
        Dir.mkdir MOVE_DIR_PATH unless Dir.exist?( MOVE_DIR_PATH )
        @player = MPlayer::Slave.new file, :path => '/usr/bin/mplayer'
        print_info_player( file )
    end

    def loadFile( file )
        begin
            Timeout.timeout(TIMEOUT_VAL) do      
                begin
                    puts "Loading   : File   : #{ file }"
                    @player.load_file file, :no_append
                    print_info_player( file )
                rescue Errno::EPIPE => e 
                    @player = MPlayer::Slave.new file, :path => '/usr/bin/mplayer'
                    print_info_player( file )
                end
            end
            rescue Timeout::Error
                print_output "Error! - Timed OUT!!!"
            end
        end

    def process_cmd( cmd, file )
        fork do
            begin
                Timeout.timeout(TIMEOUT_VAL) do      
                    @player.seek 20 if cmd == '.'
                    @player.volume :up if cmd == '0'
                    @player.volume :down if cmd == '9'
                    @player.pause if cmd == 'p'
                end
            rescue Timeout::Error
                print_output "Error! - Timed OUT!!!"
            rescue Errno::EPIPE => e
                print_output "Error! - #{ e }"
            end
        end

        loadFile( file ) if cmd == 'r'

        if cmd == 'm'
            FileUtils.mv( file, MOVE_DIR_PATH )
            puts "Moved file - #{ file } to #{ MOVE_DIR_PATH }"
            puts
        end

        if cmd == 'd'
            FileUtils.rm_rf( file ) 
            puts "Deleted file - #{ file }"
            puts
        end

        if cmd == 'i'
            print_info_player( file )
        end
    end

    def print_info_player( file )
        begin
            puts "Remaining : Total  : #{ $remain }"
            puts "File Info : File   : #{ @player.get :file_name }"
            puts "          : Rate   : #{ @player.get :audio_bitrate }"
            puts "          : Title  : #{ @player.get :meta_title }"
            puts "          : Artist : #{ @player.get :meta_artist }"
            puts "          : Album  : #{ @player.get :meta_album }"
            puts "          : Genre  : #{ @player.get :meta_genre }"
            puts "          : Time   : #{ @player.get :time_length }"
        rescue ArgumentError
            puts "Argument error in File (#{file})"
        end
    end

    def isRunning?
      begin
        @player.time_pos
        return true
      rescue Errno::EPIPE => e
        print_output "Song complete! - #{ e }"
        return false
      end
    end
   
    def quit
        @player.quit
    end
end

FILES = Dir.glob("#{ Dir.pwd }/**/*.mp3").shuffle
files = FILES
if ARGV.length == 1
  args1 = ARGV[0].downcase
  files = FILES.select{ |e| /#{args1}/  =~ e.downcase }
  if files.nil?
    puts "No files matching #{ARGV[0]}."
    exit
  end
end

$remain = files.length
@wrapper = nil
files.each do |file|
    if @wrapper.nil?
        @wrapper = MplayerWrapper.new file
    else
        @wrapper.loadFile file
    end
    while( true )
        
       cmd = ""
       begin
           Timeout.timeout(TIMEOUT_VAL) do      
               cmd = STDIN.getch
           end
       rescue Timeout::Error
           break if not @wrapper.isRunning?
       end
#end"

        @wrapper.process_cmd( cmd, file )
        if cmd == 'n' || cmd == 'd' || cmd == 'm' 
          $remain-=1
          break
        end
        if cmd == 'e'
            @wrapper.quit
            exit
        end
    end
end

# vim: ts=4:sw=4:et
