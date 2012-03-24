require "date"
require_relative "rupower/version"

module Rupower

  module Parser
    VALUE =     Regexp.new(/(([0-9]{1,5}([.][0-9]{1,5}){0,1}).*|((\S)+))$/)
    TIME =      Regexp.new(/\s+\([\s\w]*\)/)
    NUMBER =    Regexp.new(/\A[+-]?\d+?(\.\d+)?\Z/)
    UNITS =     Regexp.new(/(( .{1,2})|(%))$/)
    KEY =       Regexp.new(/\s*:\s+[\s\S]+$/)
    PARAGRAPH = Regexp.new(/^\s+/)
    VALUABLE =  Regexp.new(/\w+:\s+\S+/)
  end

  class Rupower
    def initialize( params = {})
      @refresh_always = params[:refresh_always]
      refresh
    end

    def get_all
      refresh if @refresh_always
      get_hash
    end

    def method_missing(meth,*args)
      p meth
      p args
    rescue NoMethodError
      p meth
    end

    private

      def get_hash
        @state.each_line.inject({}) do |hash, line|
          key = line.gsub(Parser::KEY,"").gsub(Parser::PARAGRAPH,"").to_sym
          line[Parser::VALUABLE] ? hash.merge(key => get_value( line )) : hash
        end
      end

      def get_value( line )
        typize (line[Parser::VALUE].gsub(Parser::UNITS,"") )
      end

      def typize( value )
        res = value[/^yes$/] ? true : false if value[/^(yes|no)$/]
        res = to_number(value) if number?(value)
        res = to_time(value) if time?(value)
        res || value
      end

      def time?(value)
        value.match(Parser::TIME)
      end

      def to_time(value)
        DateTime.parse( value ).to_time
      end

      def number?(value)
        value.match(Parser::NUMBER) == nil ? false : true
      end

      def to_number(value)
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
      device = "/org/freedesktop/UPower/devices/battery_BAT0"
      upower(device)
    end

    def line_ac
      device = "/org/freedesktop/UPower/devices/line_power_AC"
      upower(device)
    end

    private
      def upower( device )
        `upower -i #{device}`
      end
  end

end
