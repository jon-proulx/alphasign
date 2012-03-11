class AlphaSign::SignFile
  require 'alphasign/protocol'
  include AlphaSign::Protocol

  # this is just a stub for now, I feel a code reshuffle coming
  #
  # @param [AlphaSign] sign the sign object this file belongs to you
  # almost certainly want po pass self here when you call this from
  # within an AlphaSign object and almost certainly don't want to call
  # it form anywhere else.
  # @param [Symbol] type the file type :txt :string :dots :alphadots
  # @param [Hash] opts file options
  # @option opts [Integer] or [String] label file label to write to
  # or  nil (for comand modes that don't use it) any value from 0x20
  # to 0x75 except 0x30 which is reserved for "Priority Text File"
  def initialize (sign,type=:txt,opts={})

    #this is default txt file the sign sets up for display on power up
    #& should already be available un less we've messed with it
    opts[:label] =  0x41 unless opts[:label] 
    
    raise ArgumentError.new("Must pass in an AlphSign object") unless
      sign.class == AlphaSign
    
    #allow file label to be a string
    if opts[:label].class == String
      raise ArgumentError.new("File Lables can only be one character") unless
        opts[:label].legngth == 1
      #make it an Int for our further validation below
      opts[:label] = opts[:label].unpack("C")[0]
    end
    
    raise ArgumentError.new("invalid File Label specification") unless 
        ((opts[:label].kind_of? Integer) and 
         ( opts[:label]>= 0x20 and 
           opts[:label] <= 0x75 and opts[:label] != 0x30))
    
    @label=[opts[:label]].pack("C")
    @type=type
    @sign=sign
  end

  attr_reader :label, :type

end
