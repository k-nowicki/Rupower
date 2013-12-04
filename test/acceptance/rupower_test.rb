require File.expand_path( "../../../lib/rupower", __FILE__ )
require 'test/unit'
require "turn"


class RupowerTest < Test::Unit::TestCase

  def setup
    @battery = Rupower::Battery.new
    @line_ac = Rupower::LineAc.new
  end

  def test_get_all_returns_correct_hash
    assert_instance_of( Hash, @battery.get_all )
    assert_instance_of( Hash, @line_ac.get_all )
  end

  def test_charging_returns_boolean_value
    assert( @battery.charging? || !@battery.charging? )
  end

  def test_battery_get_methods_returns_correct_values
    assert_instance_of( Float,  @battery.voltage )
    assert_instance_of( String, @battery.vendor )
    assert_instance_of( String, @battery.native_path )
    assert_instance_of( DateTime, @battery.updated )
  end

  def test_line_ac_get_methods_returns_correct_values
    assert_instance_of( FalseClass, @line_ac.has_history )
    assert_instance_of( String, @line_ac.native_path )
    assert_instance_of( DateTime,   @line_ac.updated )
  end

  def test_battery_raise_no_method_error_given_invalid_method
    assert_raise NoMethodError do
      @battery.undefined_method
    end
  end

end