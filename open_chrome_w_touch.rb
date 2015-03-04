#!/usr/bin/env ruby

#gnome-terminal -x bash -c "ruby ~/open_chrome_w_touch.rb"

LOG_FILE = "~/chrome.log"

input = `xinput list | grep -i TouchScreen  | grep -v Pen | grep -o "id=[0-9][0-9]"`
input.delete!( "id=" ).strip.chomp

cmd = "google-chrome --touch-devices=#{ input }"

job = fork do
    puts "#{ cmd }"
    `#{ cmd } > #{ LOG_FILE } 2>&1 &`
end

Process.detach job
