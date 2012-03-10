require 'helper'

class TestAlphasign < Test::Unit::TestCase
  def setup
    # this test *will* fail if you don't have serialport on /dev/ttyS0 
    @sign=AlphaSign.new()
  end

  def test_simple_write
    assert_nothing_raised { @sign.write("foo" ) }
    exception=assert_raise(ArgumentError) {
      @notsign=AlphaSign.new('/dev/null') 
    }
    assert_equal("not a serial port",exception.message)
  end

  def test_write_modes
    assert_nothing_raised do
      AlphaSign::Mode.keys.each do |mode|
        @sign.write("foo", :mode => mode.to_sym)
      end
    end
  end

  def test_write_positions
    assert_nothing_raised do
      AlphaSign::Position.keys.each do |pos|
        @sign.write("foo", :position => pos.to_sym)
      end
    end
  end

  def test_write_to_file_label
    assert_nothing_raised do
      @sign.write("foo", :fileLabel=>nil)
      @sign.write("foo", :fileLabel=>0x20)
      @sign.write("foo", :fileLabel=>0x29)
      @sign.write("foo", :fileLabel=>0x31)
      @sign.write("foo", :fileLabel=>0x75)
    end    
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>"foo")}
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>0x19)}
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>0x30)}
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>0x76)}
  end
end
