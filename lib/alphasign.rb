class AlphaSign
  # Require 'serialport' gem 
  require 'serialport'

  #We have a relatively large number of potocol and formatting constants
  require 'alphasign/protocol'
  require 'alphasign/format'
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
      :default => AlphaFile.new(:txt, "A", "0100", "FF00"),
      :str1   => AlphaFile.new(:str, "B", "0050", "0000"),
      :str2   => AlphaFile.new(:str, "C", "0050", "0000"),
      :dot1   => AlphaFile.new(:dot, "D", "1078", "2000"),
      :dot2   => AlphaFile.new(:dot, "E", "1078", "2000"),
    }

    # Protocol allows multiple signs on the same port, we are not
    # going to expose that possibility yet but we will recognize this
    # as an instance variable Where "Z" all unit types, "00" is broadcast
    @addr = 'Z00'
    writemem
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

# write a memory config.  This is all at once can't add files even if
# there's unassigned memory, so what ever is written overwrites
# previous config
  private
  def writemem
    #reset memorystring
    @memorystring=StartCMD[:wfctn]+"$" # "$" is the memory function
    locked="U"
    # rebuld memory string from our current files hash damn this is
    # ugly maybe I do want files to be a Class not a Struct...
    @files.keys.each do |file|
      if @files[file].type == :str
        locked="L"
      else
        locked="U"
      end
      @memorystring=@memorystring + 
        @files[file].label +
        FileType[@files[file].type] + locked + 
        @files[file].size_spec + @files[file].time_spec
    end
    rawwrite @memorystring
  end

# the most generic write function
  private
  def rawwrite (msg)
    @device.write  StartHeader + @addr + msg + Footer
  end


end
