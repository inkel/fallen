# -*- coding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "fallen"
  s.version     = "0.0.1"
  s.summary     = "A simpler daemon library"
  s.description = "A simpler way to create Ruby fallen angels, better known as daemons"
  s.authors     = ["Leandro López"]
  s.email       = ["inkel.ar@gmail.com"]
  s.homepage    = "http://inkel.github.com/fallen"
  s.license     = "UNLICENSE"

  s.required_ruby_version = '>= 1.9.2'

  s.files       = `git ls-files`.split("\n")
end
