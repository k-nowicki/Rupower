require "date"
require_relative "rupower/version"

module Rupower

  module Parser
    VALUE =     Regexp.new( /(([0-9]{1,5}([.][0-9]{1,5}){0,1}).*|((\S)+))$/ )
    TIME =      Regexp.new( /\s+\([\s\w]*\)/ )
    NUMBER =    Regexp.new( /\A[+-]?\d+?(\.\d+)?\Z/ )
    UNITS =     Regexp.new( /(( .{1,2})|(%))$/ )
    AFTER_KEY = Regexp.new( /\s*:\s+[\s\S]+$/ )
    PARAGRAPH = Regexp.new( /^\s+/ )
    VALUABLE =  Regexp.new( /\w+:\s+\S+/ )
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
      def sym_gsub( sym, before, after )
        sym.to_s.gsub( before, after ).to_sym
      end

      def get_hash
        @state.each_line.inject( {} ) do |hash, line|
          key = line.gsub( Parser::AFTER_KEY, "" ).gsub( Parser::PARAGRAPH, "" ).to_sym
          line[Parser::VALUABLE] ? hash.merge( key => get_value( line ) ) : hash
        end
      end

      def get_value( line )
        typize( line[Parser::VALUE].gsub( Parser::UNITS, "" ) )
      end

      def typize( value )
        res = value
        res = value[/^yes$/] ? true : false if value[/^(yes|no)$/]
        res = to_number( value ) if number?( value )
        res = to_datetime( value ) if time?( value )
        res
      end

      def time?( value )
        value.match( Parser::TIME )
      end

      def to_datetime( value )
        DateTime.parse( value )
      end

      def number?( value )
        value.match( Parser::NUMBER ) == nil ? false : true
      end

      def to_number( value )
        value.to_f == value.to_i ? value.to_i : value.to_f
      end
  end

  class Battery < PowerDevice
    METHODS = [:native_path, :vendor, :model, :serial, :power_supply, :updated,
               :has_history, :has_statistics, :present, :rechargeable, :state,
               :energy, :energy_empty, :energy_full, :energy_full_design,
               :energy_rate, :voltage, :percentage, :capacity, :technology]

    METHODS.each do |method|
      define_method method do
        p method
        name_v1 = sym_gsub( method, '_', '-' )
        name_v2 = sym_gsub( method, '_', ' ' )
        get_all[ name_v1 ] || get_all[ name_v2 ]
      end
    end

    def refresh()
      @state = @command.battery
    end

    def charging?
      get_all[:state]["discharging"] ? false : true
    end
  end

  class LineAc < PowerDevice
    METHODS = [:native_path, :power_supply, :updated, :has_history, :has_statistics, :online]

    METHODS.each do |method|
      define_method method do
        p method
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
