module Rupower
  class Command
    def battery
      upower( "/org/freedesktop/UPower/devices/battery_BAT0" )
    end

    def line_ac
      upower( "/org/freedesktop/UPower/devices/line_power_AC" )
    end

    private
      def upower( device )
        `upower -i #{device}`
      end
  end
end