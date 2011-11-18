# CURRENT FILE :: lib/ar-lists/class_methods.rb
require "ar-lists/class_methods/array_accessible"
require "ar-lists/class_methods/has_list"
require "ar-lists/class_methods/option_accessible"

module ArLists

	def self.included(base)
		base.extend ClassMethods::ArrayAccessible
		base.extend ClassMethods::HasList
		base.extend ClassMethods::OptionAccessible
	end

end

class ActiveRecord::Base
  include ArLists
end
