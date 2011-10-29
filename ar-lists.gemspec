# CURRENT FILE :: ar-lists.gemspec
require File.expand_path("../lib/ar-lists/version", __FILE__)

# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name				= "ar-lists"
  s.version			= ArLists::VERSION
  s.platform		= Gem::Platform::RUBY
  s.authors			= ["Yann Hourdel"]
  s.email				= ["yann.hourdel@gmail.com"]
  s.homepage		= "http://about.me/yann.hourdel"
  s.summary			= "ar-lists-#{s.version}"
  s.description	= "Provides List-like relations for ActiveRecord Models."

  s.rubyforge_project					= "ar-lists"
  s.required_rubygems_version	= "> 1.3.6"

  s.files				= `git ls-files`.split("\n")
  s.executables	= `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact

	s.require_path	= 'lib'
end
