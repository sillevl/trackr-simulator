require 'yaml'
require './lib/os'

ttnctl = "ttnctl-windows-amd64" if OS.windows?
ttnctl = "ttnctl-linux-amd64" if OS.linux?
ttnctl = "ttnctl-darwin-amd64" if OS.mac?

unless defined? ttnctl
  puts "Operating system not supported"
  exit
end

settings = YAML.load_file("settings.yml")['ttn']
data = YAML.load_file("data.yml")

acknowledge = 0
frame = 0

loop do

  data.each do |payload|
    command =   "./ttnctl/#{ttnctl} " +      # executable
      "uplink " +                              # command
      "#{acknowledge.to_s} " +                 # no-acknowledge
      "#{settings['device_address']} " +       # device address
      "#{settings['network_session_key']} " +  # network session key
      "#{settings['app_session_key']} " +      # application session key
      "#{payload} " +                          # payload / data
      "#{frame.to_s}"                          # frame counter

    frame += 1
    system(command)
    sleep 5
  end
end
