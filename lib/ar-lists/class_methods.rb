# CURRENT FILE :: lib/ar-lists/engine.rb
module ArLists

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods
    
    # attr_name	: the attribute
    # uniq			: wether to act like a group (if true) or like an array (if false)
    # encode		: encoding function (must return a String)
    # decode		: decoding function (takes a String as argument)
		def array_accessible(attr_name, options = {})
			do_uniq = false || options[:uniq]
			attr_accessible attr_name

			encode = options.has_key?(:encode) ? options[:encode] : lambda {|v| return v.to_s}
			decode = options.has_key?(:decode) ? options[:decode] : lambda {|v| return v}

			define_method "#{attr_name}=" do |values|
				val = [values].flatten.map{|v| encode.call(v).split(',')}.flatten.reject{|v| v.blank?}
				val.uniq! if do_uniq
				write_attribute attr_name, val.join(',')
			end
			define_method "#{attr_name}" do
				val = read_attribute attr_name
				val.blank? ? [] : decode.call(val).split(',')
			end
		end

		# attr_name		: the attribute
		# uniq				: wether to act like a group (if true) or like an array (if false)
		# strict			: wether to throw an error when a Record cannot be found
		# polymorphic	: wether to type the elements (if true) or not (if false)
		# class_name	: the type to use when polymorphic is false
		def has_list(attr_name, options = {})

			do_uniq = false || options[:uniq]
			strict = false || options[:strict]
			is_typed = false || options[:polymorphic]

			unless is_typed
				class_name = options[:class_name].blank? ? attr_name.singularize.classify : options[:class_name]
				attr_accessible attr_name, "#{attr_name}_ids"
				define_method "#{attr_name}_ids=" do |values|
					val = [values].flatten.map{|v| v.to_s.split(',')}.flatten.reject{|v| v.blank?}
					val.uniq! if do_uniq
					write_attribute attr_name, val.join(',')
				end
				define_method "#{attr_name}_ids" do
					val = read_attribute attr_name
					val.blank? ? [] : val.split(',').map{|s| s.to_i}
				end
			end

			define_method "#{attr_name}=" do |records|
				val = records.map{|r|
					if is_typed
						"#{r.class}:#{r.id}"
					else
						"#{r.id}"
					end
				}
				val.uniq! if do_uniq
				write_attribute attr_name, val.join(',')
			end
			define_method "#{attr_name}" do
				val = read_attribute attr_name
				val.blank? ? [] : val.split(',').map{|r_code|
					begin
						if is_typed
							code = r_code.split(':')
							code[0].classify.constantize.find(code[1].to_i)
						else
							class_name.constantize.find(r_code)
						end
					rescue ActiveRecord::RecordNotFound
						throw "Unable to build list: RecordNotFound" if strict
						[]
					end
				}.flatten
			end
		end

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

class ActiveRecord::Base
  include ArLists
end
