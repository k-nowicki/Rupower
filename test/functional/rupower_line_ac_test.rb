require File.expand_path( "../../../lib/rupower", __FILE__ )
require 'test/unit'
require "turn"


class RupowerLineAcTest < Test::Unit::TestCase

  def setup
    @line_ac = Rupower::LineAc.new( :command => CommandStub.new )
  end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def test_native_path_returns_correct_value
    assert_equal(
        "/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:09/PNP0C09:00/ACPI0003:00/power_supply/AC",
        @line_ac.native_path )
  end

  def test_power_supply_returns_correct_value
    assert_equal( true, @line_ac.power_supply )
  end

  def test_updated_returns_correct_value
    assert_equal( DateTime.parse("Sat Mar 24 20:12:24 2012"), @line_ac.updated )
  end

  def test_has_history_returns_correct_value
    assert_equal( false, @line_ac.has_history )
  end

  def test_has_statistics_returns_correct_value
    assert_equal( false, @line_ac.has_statistics )
  end

  def test_online_returns_correct_value
    assert_equal( true, @line_ac.online )
  end

end