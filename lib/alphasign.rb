class AlphaSign
  require 'serialport'
  #Alpha serial port settings
  Baud=9600
  DataBits=7
  Parity=SerialPort::EVEN
  StopBits=2
  
  #this was much more complex in original, but due to packing spec
  #effectively reduced to this, and remains voodoo but apparently
  #necessary voodoo
  Preamble = [ ']', ']'].pack('x10ax10a')
  # everything starts with this, nulls are to auto set baud on unit
  StartHeader = alphaPreamble + [ 0x01 ].pack('x20C')
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
  
  # mode bits see proto doc section 4.2.4 for possibilities
  StartMode = [ 0x1b ].pack('C')
  # Position
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
  
  # Where "Z" all units, "00" first unit or broadcast?
  alddr = [ 'Z00' ].pack('A3') 
  
  alphaFormat = StartMode + Position[:middle] + Mode[:fill]
  alphaHeader = alphaStartHeader + alphaAddr + alphaStartCMD[:wtxt] + alphaFormat



end
