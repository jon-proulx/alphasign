# These are a pile of constants for the protocol functions
# @see AlphaSign::Format for constants users may want to interact with
module AlphaSign::Protocol
  
  ###Serial config
  Baud=9600
  DataBits=7
  Parity=SerialPort::EVEN
  StopBits=2
  ###

  #this was much more complex in original, but due to packing spec
  #effectively reduced to this, and remains voodoo but apparently
  #necessary voodoo
  Preamble = [ ']', ']'].pack('x10ax10a')
  # everything starts with this, nulls are to auto set baud on unit
  StartHeader = Preamble + [ 0x01 ].pack('x20C')

  # only handlers for :wtxt implemented so far
  StartCMD = {
    :wtxt => [ 0x02, 'A' ].pack('CA'), # write text file
    :rtxt => [ 0x02, 'B' ].pack('CA'), # read text file
    :wfctn => [ 0x02, 'E' ].pack('CA'), # write special function
    :rfctn => [ 0x02, 'F' ].pack('CA'), # read special function
    :wstr => [ 0x02, 'G' ].pack('CA'), # write string file
    :rstr => [ 0x02, 'H' ].pack('CA'), # read string file
    :wdots => [ 0x02, 'I' ].pack('CA'), # write DOTS picture file
    :rdots => [ 0x02, 'J' ].pack('CA'), # read DOTS picture file
    :wadots => [ 0x02, 'M' ].pack('CA'), # write ALPHAVISON DOTS picture file
    :radots => [ 0x02, 'N' ].pack('CA'), # read ALPHAVISON DOTS picture file
    :bulletin => [ 0x02, 'O' ].pack('CA'), # write bulletin message
  } 

  AlphaFile=Struct.new(:name,:type,:size_spec,:time_spec)
  
  Footer = [0x04].pack("C") # EOT end of transmission
  
end
