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
  # only :wtxt command as thats the only one we know we can do
   def  write (msg, position=:middle, mode=:hold)
     @fileLabel = [ 0x41 ].pack("C") # any value from 0x20 to 0x75
                                     # except 0x30 which is reserved
                                     # for "Priority Text" file
                                     # according to docs
     @alphaFormat = StartMode + Position[position] + Mode[mode]
     @alphaHeader =  StartHeader + @addr +  StartCMD[:wtxt] + @fileLabel + @alphaFormat
     sp=SerialPort.new(@device,  
                     Baud,  DataBits,  StopBits,  Parity)
     sp.write @alphaHeader
     sp.write msg
     sp.write Footer
     sp.close
   end



end
