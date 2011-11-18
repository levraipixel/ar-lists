# CURRENT FILE :: lib/ar-lists/class_methods/option_accessible.rb
module ArLists

	module ClassMethods

		module OptionAccessible

			# attr_name : attribute
			# values    : Hash of value => display name
			# default   : default value
			def option_accessible(attr_name, _values, default)
				if _values.is_a? Hash
					values = _values
				else
					values = Hash[_values.map{|value| [value, value]}]
				end
				values.default = values[default]
				attr_accessible attr_name
				define_method "#{attr_name}=" do |value|
					write_attribute attr_name, (values.has_key?(value) ? value : default)
				end
				define_method "#{attr_name}" do
					value = read_attribute attr_name
					values.has_key?(value) ? value : default
				end
				define_method "#{attr_name}_display" do
					values[read_attribute(attr_name)]
				end
				(class << self; self; end).send(:define_method, "#{attr_name}_options") do
					values
				end
			end
		
		end
   
  end
  
end
