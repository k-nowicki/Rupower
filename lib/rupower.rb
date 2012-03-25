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

  class Rupower
    def initialize( params = {refresh_always:true} )
      @refresh_always = params[:refresh_always]
      refresh
    end

    def get_all
      refresh if @refresh_always
      get_hash
    end

    def method_missing( meth, *args )
      name_v1 = sym_gsub( meth, '_', '-' )
      name_v2 = sym_gsub( meth, '_', ' ' )
      res = get_all[ name_v1 ] || get_all[ name_v2 ]
      raise NoMethodError, "undefined method #{meth} for Rupower::Battery" if res.class == NilClass
      res
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
        res = to_time( value ) if time?( value )
        res
      end

      def time?( value )
        value.match( Parser::TIME )
      end

      def to_time( value )
        DateTime.parse( value ).to_time
      end

      def number?( value )
        value.match( Parser::NUMBER ) == nil ? false : true
      end

      def to_number( value )
        value.to_f == value.to_i ? value.to_i : value.to_f
      end
  end

  class Battery < Rupower
    def refresh
      @state = Command.new.battery
    end

    def charging?
      get_all[:state]["discharging"] ? false : true
    end
  end

  class LineAc < Rupower
    def refresh
      @state = Command.new.line_ac
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
