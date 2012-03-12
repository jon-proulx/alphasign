# Constants for format codes users may want to include
# @see AlphaSign::Protocol for protocol constants
module AlphaSign::Format
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
  Mode = {
    :rotate => "a", #scroll right to left
    :hold => "b", # stationary
    :flash => "c", #"flash"
    # these are all transitions from previous message:
    :rollup => "e",
    :rolldown => "f",
    :rollleft => "g",
    :rollright => "h",
    :wipeup => "i",
    :wipedown => "j",
    :wipeleft => "k",
    :wiperight => "l",
    :scroll => "m", # push bottom line to top (2line units only)
    :auto => "o", 
    :rollin => "p",
    :rollout => "q",
    :wipein => "r",
    :wipeout => "s",
    :compressed_rotate => "t", 
    # only certain (unspecified) models
    # special modes, note these are ascii "n" and ascii digits so "1"
    # is 0x31 not not 0x01 
    :twinkle => "n0", 
    :sparkle => "n1",
    :snow => "n2",
    :interlock => "n3",
    :switch => "n4",
    :slide => "n5",
    :spray => "n6",
    :starburst => "n7",
    # @note special graphics are not display modes, though they are in
    # the same manual seciton and transmision frame placement.  If
    # ASCII message data is to b edisplayed following a special
    # graphic, another mode field is required other wise the message
    # will appear in "automode"
    :script_welcome => "n8",
    :slot_machine => "n9",
    :script_thx => "nS",
    :no_smoking => "nU",
    :dont_drink_drive => "nV",
    :running_animal => "nW",
    :fireworks => "nX",
    :turbo_car => "nY",
    :cherry_bomb => "nZ",
  }
  
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
    :std5 => [0x1a,0x31].pack("C2"),
    :std7 => [0x1a,0x33].pack("C2"),
    :fancy7 => [0x1a,0x35].pack("C2"),
    :std10 => [0x1a,0x36].pack("C2"),
    :fullfancy => [0x1a,0x38].pack("C2"),
    :fullstd => [0x1a,0x39].pack("C2"),
  }
  
  # speeds from slow to fast
  Speed = [ [0x15].pack("C"), [0x16].pack("C"), [0x17].pack("C"),
            [0x18].pack("C"), [0x19].pack("C") ]

  #Control Codes (for insertion in text file data)
  CallString = [0x10].pack("C") # call a saved string file, must be followed but filelabel for a string file...
  CallDots = [0x14].pack("C") # call a saved Dots Picture file, must be followed but filelabel for a dots file...
  DoubleHighOn = [0x05,0x31].pack("C2") # not supported on all units
  DoubleHighOff= [0x05,0x30].pack("C2") # default
  TrueDecendersOn = [0x06,0x31].pack("C2") # not supported on all units
  TrueDecendersOff= [0x06,0x30].pack("C2") # default
  FlashCharOn = [0x07,0x31].pack("C2") # not supported on all units
  FlashCharOff= [0x07,0x30].pack("C2") # default
  FixWidth=[0x1E,0x31].pack("C2") # set fixed width useful for string files
  Extended=[0x08].pack("C") # access extended ascci of following char for example Extended + "I" would put a degree symbol on the display, see docs

  TempF=[0x08,0x1C].pack("C2") #only available on incandescent message centers
  TempC=[0x08,0x1D].pack("C2") #only available on incandescent message centers
  Count1=[0x08,0x7A].pack("C2") #display current value of counter 1
  Count2=[0x08,0x7B].pack("C2") #display current value of counter 2
  Count3=[0x08,0x7C].pack("C2") #display current value of counter 3
  Count4=[0x08,0x7D].pack("C2") #display current value of counter 4
  Count5=[0x08,0x7E].pack("C2") #display current value of counter 5

  
end
