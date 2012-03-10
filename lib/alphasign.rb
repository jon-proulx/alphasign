class AlphaSign
  # Require 'serialport' gem 
  require 'serialport'

  #We have a relatively large number of potocol and formatting constants
  require 'alphasign/protocol'
  require 'alphasign/format'
  require 'alphasign/signfile'
  include AlphaSign::Protocol
  include AlphaSign::Format


  # @param [String] device the serial device the sign is connected to
  # for now we only speak rs232
  def  initialize (device = "/dev/ttyS0")
    @device=SerialPort.new(device, Baud,  DataBits,  StopBits,  Parity) 
    # default file setup, we should read this from the device, for now
    # just enforce our own & hope no other process is messing with it
    # (that's why we're 0.x.x)
    @files={
      :default => AlphaSign::SignFile.new(:txt,:fileLabel=>"A")
    }

    # Protocol allows multiple signs on the same port, we are not
    # going to expose that possibility yet but we will recognize this
    # as an instance variable Where "Z" all units, "00" first unit or
    # broadcast?
    @addr = [ 'Z00' ].pack('A3')
    
  end

  # we don't have an open yet so this still kludgey and enfoces using
  # only :wtxt command as thats the only one we know we can do @param
  # @param [STRING] msg the message (text file in Alpha parlance) 
  # @see AlphaSign::Format for control characters for color, font, etc.
  # @param [HASH] opts the write options
  # @option opts [Symbol] :position display position @see AlphaSign::Format::Position 
  # @options opts [Symbol] :mode display mode @see AlphaSign::Format::Mode

  def  write (msg, opts={ })

    # default to middle position
    opts[:position]=:middle unless opts[:position] 

    #default to static display
    opts[:mode]=:hold unless opts[:mode] 

    # sign file to write to, carefule these need to be setup before
    # they can be written to...
    opts[:filename]=:default unless opts [:filename]
 
    @format = StartMode + Position[opts[:position]] + Mode[opts[:mode]]

    rawwrite  StartCMD[:wtxt]+ @files[opts[:filename]].label + @format + msg 
   end

# the most generic write function
  private
  def rawwrite (msg)
    @device.write  StartHeader + @addr + msg + Footer
  end
end
