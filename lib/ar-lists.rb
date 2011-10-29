# CURRENT FILE :: lib/ar-lists.rb

module ArLists

	# Yield self on setup for nice config blocks
	def self.setup
		yield self
	end

end

# Require our engine
require "ar-lists/class_methods"
