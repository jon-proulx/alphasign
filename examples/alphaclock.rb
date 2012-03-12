#!/usr/bin/env ruby 
#
# This program display a clock on your alpha sign
#
# It uses a "String" file to hold the formatted time.  String files
# use buffered writes so the display doesn't blank like it does when
# writing "text" files, but they are limited to 125 bytes each max
#
# File types need to be set in memory before they can used, both their
# type and size. For simplicity we use the default memory setup
# provided by AlphaSign.new :default is a text file of 256 bytes max
# and :str2 is a string file of 80 bytes max
require 'rubygems'
require 'alphasign'

# use second of the two default string files
stringfile=:str2
sign=AlphaSign.new
#seconds to sleep before refresh (signs can only handle updates every
#2 sec or so)
interval=5

# write our message to the default text file
#
# setting color, fixed text, and call our variable string file
sign.write(AlphaSign::Color[:amber] + 
           "the time is " + sign.callstr(stringfile))

#update stringfile every interval seconds
while 1 
  time = Time.new
  # put time in our stringfile
  # use fixed width so line doesn't squirm around when digits change
  # this does force left justification rather than center
  # set color, then write time
  sign.writestr(AlphaSign::FixWidth + AlphaSign::Color[:green] + 
                time.strftime("%I:%M:%S %p"),stringfile)
  sleep interval - time.sec.modulo(interval)
end
