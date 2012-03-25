# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rupower/version"

Gem::Specification.new do |s|
  s.name        = "rupower"
  s.version     = Rupower::VERSION
  s.authors     = ["k-nowicki"]
  s.email       = ["karol@knowicki.pl"]
  s.homepage    = "https://github.com/k-nowicki/rupower"
  s.summary     = %q{Rupower is UPower (http://upower.freedesktop.org) interface for Ruby.}
  s.description = %q{Rupower is UPower (http://upower.freedesktop.org) interface for Ruby, working for Battery and AC supply.
The main use case is to get all information providing by appropriate UPower service as parsed, hard typing hash.}
  s.required_ruby_version = '>= 1.9.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
