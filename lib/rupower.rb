require "date"
require_relative "rupower/version"

module Rupower

  module Parser
    NUMBER =    Regexp.new(/^\d+[.]?\d*(|[%]|\s+\w+)$/)  #( /\A[+-]?\d+?(\.\d+)?\Z/ )
    TIME   = Regexp.new(/\d{4}\s(\d{2}:){2}\d{2}\s/)
  end

  class PowerDevice
    def initialize( params = {refresh_always:true} )
      @refresh_always = params[:refresh_always]
      @command = params[:command] || Command.new
      refresh
    end

    def get_all
      refresh if @refresh_always
      get_hash
    end

    private
      def get_hash
        state = @state.strip.split( /$/ ).map( &:strip ).reject{ |r| !r.include?( ':' ) }
        state_key_value_array = state.map{ |r| r.split( ':', 2 ) }.flatten.map( &:strip )
        symbolize_hash( Hash[*state_key_value_array.map{ |value| typize(value) }] )
      end

      def typize( value )
        res = value
        res = value[/^yes$/] ? true : false if value[/^(yes|no)$/]
        res = value.to_f == value.to_i ? value.to_i : value.to_f  if value[Parser::NUMBER ]
        res = DateTime.parse( value ) if value.match( Parser::TIME )
        res
      end

      def symbolize_hash(hash)
        hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      end

      def sym_gsub( sym, before, after )
        sym.to_s.gsub( before, after ).to_sym
      end

  end

  class Battery < PowerDevice
    METHODS = [:native_path, :vendor, :model, :serial, :power_supply, :updated,
               :has_history, :has_statistics, :present, :rechargeable, :state,
               :energy, :energy_empty, :energy_full, :energy_full_design,
               :energy_rate, :voltage, :percentage, :capacity, :technology]

    METHODS.each do |method|
      define_method method do
        name_v1 = sym_gsub( method, '_', '-' )
        name_v2 = sym_gsub( method, '_', ' ' )
        get_all[ name_v1 ] || get_all[ name_v2 ]
      end
    end

    def refresh
      @state = @command.battery
    end

    def charging?
      get_all[:state] == "charging"
    end

    def fully_charged?
      get_all[:state] == "fully-charged"
    end
  end

  class LineAc < PowerDevice
    METHODS = [:native_path, :power_supply, :updated, :has_history, :has_statistics, :online]

    METHODS.each do |method|
      define_method method do
        name_v1 = sym_gsub( method, '_', '-' )
        name_v2 = sym_gsub( method, '_', ' ' )
        get_all[ name_v1 ] || get_all[ name_v2 ]
      end
    end

    def refresh
      @state = @command.line_ac
    end
  end

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
