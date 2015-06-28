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

def print_output( o )
    puts o if SHOW_DEBUG
end

class MplayerWrapper
    def initialize( songs_files, listen  )
        @files = songs_files
        `pkill mplayer`
        @listening_mode = listen
        @remain = @files.length
        print_commands
    end

    def print_commands()
        puts "Commands  :"
        puts "Next      : n"
        puts "Replay    : r"
        puts "Pause     : p"
        puts "Forward   : ."
        puts "Vol up    : 0"
        puts "Vol down  : 9"
        puts "Exit      : e"
        if not @listening_mode
            puts "Delete    : d"
            puts "Move      : m"
        end
        puts ""
    end

    def play()
        @files.each do |file|
            loadFile( file )
            @remain-=1
            while( true )
                cmd = ""
                begin
                    Timeout.timeout(TIMEOUT_SONG_END_CHECK) do      
                        cmd = STDIN.getch
                    end
                rescue Timeout::Error
                    break if not isRunning?
                end
                break if process_cmd( cmd, file )
            end
        end
        print "DONE:\n"
    end

    def loadFile( file )
        @player = MPlayer::Slave.new file, :path => '/usr/bin/mplayer' if @player.nil?
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

        ( print_info_player( file );return false ) if cmd == 'i'
        ( loadFile( file );return false ) if cmd == 'r'
        return move_file( file )  if cmd == 'm'
        return delete_file( file ) if cmd == 'd'
        ( return true ) if cmd == 'n'
        ( quit;exit ) if cmd == 'e'
    end

    def move_file( file )
        ( print "Cannot move file in Listening mode.\n";return false ) if @listening_mode 
        Dir.mkdir MOVE_DIR_PATH unless Dir.exist?( MOVE_DIR_PATH )
        FileUtils.mv( file, MOVE_DIR_PATH )
        puts "Moved file - #{ file } to #{ MOVE_DIR_PATH }"
        puts
        return true
    end

    def delete_file( file )
        ( print "Cannot delete file in Listening mode.\n";return false ) if @listening_mode 
        FileUtils.rm_rf( file ) 
        puts "Deleted file - #{ file }"
        puts
        return true
    end

    def print_info_player( file )
        info = ""
        count = 2
        while( count  )
            begin
                info = "Remaining : Total  : #{ @remain }\n"
                info += "File Info : File   : #{ @player.get :file_name }"
                info += "          : Rate   : #{ @player.get :audio_bitrate }"
                info += "          : Title  : #{ @player.get :meta_title }"
                info += "          : Artist : #{ @player.get :meta_artist }"
                info += "          : Album  : #{ @player.get :meta_album }"
                info += "          : Genre  : #{ @player.get :meta_genre }"
                info += "          : Time   : #{ @player.get :time_length }"
                info += "\n"
                break
            rescue ArgumentError
                print_output "Argument error in File (#{file})"
                sleep 2
                count-=1
            end
        end
        puts info
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
        `pkill mplayer`
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

@wrapper = MplayerWrapper.new files, false
@wrapper.play


# vim: ts=4:sw=4:et
