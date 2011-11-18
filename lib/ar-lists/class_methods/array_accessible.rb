# CURRENT FILE :: lib/ar-lists/class_methods/array_accessible.rb
module ArLists

	module ClassMethods
    
    module ArrayAccessible

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

		end
		
	end
	
end
