class AlphaSign
  # Require 'serialport' gem 
  require 'serialport'
  
  #We have a relatively large number of potocol constants

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
  # this is still a bit dubious, docs say "A" for write text file, but
  # example and experience show "AA" is needed, other codes are as yet
  # untested YMMV..I simply doubled the char listed in docs. only 'wtxt'
  # actually works with anything else here
  StartCMD = {
    :wtxt => [ 0x02, 'AA' ].pack('CA2'), # write text file
    :rtxt => [ 0x02, 'BB' ].pack('CA2'), # read text file
    :wfctn => [ 0x02, 'EE' ].pack('CA2'), # write special function
    :rfctn => [ 0x02, 'FF' ].pack('CA2'), # read special function
    :wstr => [ 0x02, 'GG' ].pack('CA2'), # write string file
    :rstr => [ 0x02, 'HH' ].pack('CA2'), # read string file
    :wdots => [ 0x02, 'II' ].pack('CA2'), # write DOTS picture file
    :rdots => [ 0x02, 'JJ' ].pack('CA2'), # read DOTS picture file
    :wadots => [ 0x02, 'MM' ].pack('CA2'), # write ALPHAVISON DOTS picture file
    :radots => [ 0x02, 'NN' ].pack('CA2'), # read ALPHAVISON DOTS picture file
    :bulletin => [ 0x02, 'OO' ].pack('CA2'), # write bulletin message
  } 
  
  # Marker for start of mode config
  StartMode = [ 0x1b ].pack('C')

  # Vertical Position
  Position = {
    :middle => [ 0x20 ].pack('C'),
    :top => [ 0x22 ].pack('C'),
    :bottom => [ 0x26 ].pack('C'),
    :fill => [ 0x30 ].pack('C'),
  }
  # Mode Code, names taken form documentation
  # since these are ascii probably don't need packing?
  Mode = {
    :rotate => ["a"].pack('A'), #scroll right to left
    :hold => ["b"].pack('A'), # stationary
    :flash => ["c"].pack('A'), #"flash"
    # these are all transitions from previous message:
    :rollup => ["e"].pack('A'),
    :rolldown => ["f"].pack('A'),
    :rollleft => ["g"].pack('A'),
    :rollright => ["h"].pack('A'),
    :wipeup => ["i"].pack('A'),
    :wipedown => ["j"].pack('A'),
  }

  Footer = [0x04].pack("C") # EOT end of transmission
  
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
     @alphaFormat = StartMode + Position[position] + Mode[mode]
     @alphaHeader =  StartHeader + @addr +  StartCMD[:wtxt] + @alphaFormat
     sp=SerialPort.new(@device,  
                     Baud,  DataBits,  StopBits,  Parity)
     sp.write @alphaHeader
     sp.write msg
     sp.write Footer
     sp.close
   end



end
