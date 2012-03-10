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
  
end
