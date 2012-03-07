require 'helper'

class TestAlphasign < Test::Unit::TestCase
  def setup
    @sign=AlphaSign.new()
    @notsign=AlphaSign.new('/dev/null')
  end

  def test_simple_write
    assert_nil( @sign.write("foo" )) # this test *will* fail if you don't have serialport on /dev/ttyS0 
    exception=assert_raise(ArgumentError) { @notsign.write("foo" ) }
    assert_equal("not a serial port",exception.message)
  end

  def test_write_modes
    AlphaSign::Mode.keys.each do |mode|
      assert_nil(@sign.write("foo", :mode => mode.to_sym))
    end
  end

  def test_write_positions
    AlphaSign::Position.keys.each do |pos|
      assert_nil(@sign.write("foo", :position => pos.to_sym))
    end
  end

  def test_write_to_file_label
    assert_nil(@sign.write("foo", :fileLabel=>nil))
    assert_nil(@sign.write("foo", :fileLabel=>0x20))
    assert_nil(@sign.write("foo", :fileLabel=>0x29))
    assert_nil(@sign.write("foo", :fileLabel=>0x31))
    assert_nil(@sign.write("foo", :fileLabel=>0x75))
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>"foo")}
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>0x19)}
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>0x30)}
    assert_raise(ArgumentError) {@sign.write("foo", :fileLabel=>0x76)}
  end
end
