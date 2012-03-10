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

end
