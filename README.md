# Rupower

Ruby interface to [UPower] tool available by default on Ubuntu and Debian distros.

## Example

    battery = Rupower::Battery.new
    battery.serial          # =>   5981
    battery.voltage         # =>  12.15     # [V]
    battery.energy_rate:    # =>   18.97    # [W]
    percentage:             # =>   77.36    # [%]
    capacity:               # =>   100      # [%]
    technology:             # =>   'lithium-ion'

See the UPower documentation for full list of parameters that can be used as methods, or look at the
acceptance tests.

## Installation

Add this to your Gemfile:

    gem 'rupower'

Then run:

    bundle

## Requirements

 * Ruby >= 1.9.2

## Running tests

    bundle exec rake test

## License

Released under the MIT license. Copyright (C) 2012 Karol Nowicki

[UPower]: http://upower.freedesktop.org