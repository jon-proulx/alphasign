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
  
  # standard color codes, limited by hardware
  Color = {
    :red => [0x1c,0x31].pack("C2"),
    :green => [0x1c,0x32].pack("C2"),
    :amber => [0x1c,0x33].pack("C2"),
    :dimred => [0x1c,0x34].pack("C2"),
    :dimgreen => [0x1c,0x35].pack("C2"),
    :brown => [0x1c,0x36].pack("C2"),
    :orange => [0x1c,0x37].pack("C2"),
    :yellow => [0x1c,0x38].pack("C2"),
    :rainbow1 => [0x1c,0x39].pack("C2"),
    :rainbow2 => [0x1c,0x41].pack("C2"),
    :mix => [0x1c,0x42].pack("C2"),
    :auto => [0x1c,0x43].pack("C2"),
  }

  # Character sets height & style
  CharSet = {
    :5std => [0x1a,0x31].pack("C2"),
    :7std => [0x1a,0x33].pack("C2"),
    :7fancy => [0x1a,0x35].pack("C2"),
    :10std => [0x1a,0x36].pack("C2"),
    :fullfancy => [0x1a,0x38].pack("C2"),
    :fullstd => [0x1a,0x39].pack("C2"),
  }

  # speeds from slow to fast
  Speed = [ [0x15].pack("C"), [0x16].pack("C"), [0x17].pack("C"),
            [0x18].pack("C"), [0x19].pack("C") ]

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
