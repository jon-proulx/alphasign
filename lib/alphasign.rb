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
    @device= device

    # Protocol allows multiple signs on the same port, we are not
    # going to expose that possibility yet but we will recognize this
    # as an instance variable Where "Z" all units, "00" first unit or
    # broadcast?
    @addr = [ 'Z00' ].pack('A3')
    
  end

  # we don't have an open yet so this still kludgey and enfoces using
  # only :wtxt command as thats the only one we know we can do @param
  # @param [STRING] msg the message (text file in Alpha parlance) @see AlphaSign::Format
  # for control characters for color, font, etc.
  # @param [HASH] opts the write options
  # @option opts [Symbol] :position display position @see AlphaSign::Format::Position 
  # @options opts [Symbol] :mode display mode @see AlphaSign::Format::Mode
  # @options opts [Integer] or [Nil] :fileLabel file label to write to
  # or  nil (for comand modes that don't use it) any value from 0x20
  # to 0x75 except 0x30 which is reserved
  def  write (msg, opts={ })
    opts[:position]=:middle unless opts[:position] # default to middle position
    opts[:mode]=:hold unless opts[:mode] #default to static display
    opts[:fileLabel] =  0x41 unless opts[:fileLabel] #this was default in exampelso why not..

    raise ArgumentError.new("unkown position #{opts[:position]}") unless Position.has_key?(opts[:position])
    raise ArgumentError.new("unkown mode #{opts[:mode]}") unless Mode.has_key?(opts[:mode])
    raise ArgumentError.new("invalid File Label specification") unless (opts[:fileLabel] == nil) or  ((opts[:fileLabel].kind_of? Integer) and ( opts[:fileLabel] >= 0x20 and opts[:fileLabel] <= 0x75 and opts[:fileLabel] != 0x30))
    if opts[:fileLabel] == nil
      @filelabel=""
    else
      @filelabel=[opts[:fileLabel]].pack("C")
    end

     @alphaFormat = StartMode + Position[opts[:position]] + Mode[opts[:mode]]
     @alphaHeader =  StartHeader + @addr +  StartCMD[:wtxt] + @filelabel + @alphaFormat
     sp=SerialPort.new(@device,  
                     Baud,  DataBits,  StopBits,  Parity)
     sp.write @alphaHeader
     sp.write msg
     sp.write Footer
     sp.close
   end



end
