require File.expand_path( "../../../lib/rupower", __FILE__ )
require File.expand_path( "../../stubs/command_stub", __FILE__ )
require 'test/unit'
require "turn"


class RupowerBatteryTest < Test::Unit::TestCase

  def setup
    @battery = Rupower::Battery.new( :command => CommandStub.new )
  end

  def test_native_path_returns_correct_value
    assert_equal(
        "/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:09/PNP0C09:00/PNP0C0A:00/power_supply/BAT0",
        @battery.native_path )
  end

  def test_vendor_returns_correct_value
    assert_equal( "SONY", @battery.vendor )
  end

  def test_model_returns_correct_value
    assert_equal( "42T4795", @battery.model )
  end

  def test_serial_returns_correct_value
    assert_equal( 6804, @battery.serial )
  end

  def test_power_supply_returns_correct_value
    assert_equal( true, @battery.power_supply )
  end

  def test_updated_returns_correct_value
    assert_equal( DateTime.parse("Sun Mar 25 20:12:15 2012"), @battery.updated )
  end

  def test_has_history_returns_correct_value
    assert_equal( true, @battery.has_history )
  end

  def test_has_statistics_returns_correct_value
    assert_equal( true, @battery.has_statistics )
  end

  def test_present_returns_correct_value
    assert_equal( true, @battery.present )
  end

  def test_rechargeable_returns_correct_value
    assert_equal( true, @battery.rechargeable )
  end

  def test_state_returns_correct_value
    assert_equal( "fully-charged", @battery.state )
  end

  def test_energy_returns_correct_value
    assert_equal( 62.9532, @battery.energy )
  end


  def test_energy_empty_returns_correct_value
    assert_equal( 0, @battery.energy_empty )
  end

  def test_energy_full_returns_correct_value
    assert_equal( 63.8928, @battery.energy_full )
  end

  def test_energy_full_design_returns_correct_value
    assert_equal( 60.6528, @battery.energy_full_design )
  end

  def test_energy_rate_returns_correct_value
    assert_equal( 0, @battery.energy_rate )
  end

  def test_voltage_returns_correct_value
    assert_equal( 12.187, @battery.voltage )
  end

  def test_percentage_returns_correct_value
    assert_equal( 98.5294, @battery.percentage )
  end

  def test_capacity_returns_correct_value
    assert_equal( 100, @battery.capacity )
  end

  def test_technology_returns_correct_value
    assert_equal( "lithium-ion", @battery.technology )
  end


end