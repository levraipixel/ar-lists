# CURRENT FILE :: ar-lists.gemspec

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ar-lists/version"

Gem::Specification.new do |s|
  s.name				= "ar-lists"
  s.version			= ArLists::VERSION
  s.platform		= Gem::Platform::RUBY
  s.authors			= ["Yann Hourdel"]
  s.email				= ["yann.hourdel@gmail.com"]
  s.homepage		= "http://about.me/yann.hourdel"

  s.required_rubygems_version	= "> 1.3.6"

  s.files					= `git ls-files`.split("\n")
  s.test_files		= `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths	= ["lib"]

  s.summary			= "ar-lists-#{s.version}"
  s.description	= "Provides List-like relations for ActiveRecord Models."
end
