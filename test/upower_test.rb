require File.expand_path( "../../lib/rupower", __FILE__ )
require 'test/unit'
require "turn"

class UpowerTest < Test::Unit::TestCase

  def test_get_all_returns_correct_hash
    assert_instance_of(Hash, Rupower::Battery.new.get_all)
    assert_instance_of(Hash, Rupower::LineAc.new.get_all)
  end

  def test_charging_returns_boolean_value
    assert( Rupower::Battery.new.charging? || !Rupower::Battery.new.charging? )
  end

  def test_battery_get_methods_returns_correct_values
    assert_instance_of( Float,  Rupower::Battery.new.voltage)
    assert_instance_of( String, Rupower::Battery.new.vendor)
    assert_instance_of( String, Rupower::Battery.new.native_path)
    assert_instance_of( Time,   Rupower::Battery.new.updated)
  end

  def test_line_ac_get_methods_returns_correct_values
    assert_instance_of( FalseClass, Rupower::LineAc.new.has_history)
    assert_instance_of( String, Rupower::LineAc.new.native_path)
    assert_instance_of( Time,   Rupower::LineAc.new.updated)
  end

  def test_battery_raise_no_method_error_given_invalid_method
    assert_raise NoMethodError do
      Rupower::Battery.new.undefined_method
    end
  end

end