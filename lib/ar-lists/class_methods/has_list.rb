# CURRENT FILE :: lib/ar-lists/class_methods/has_list.rb
module ArLists

	module ClassMethods

		module HasList

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
					class_name = options[:class_name].blank? ? attr_name.to_s.singularize.classify : options[:class_name]
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
        define_method "#{attr_name}_count" do
    			val = read_attribute attr_name
					val.blank? ? 0 : val.split(',').count
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
				if is_typed
					scope "with_#{attr_name}_containing", lambda {|r|
						where("(#{attr_name} = '#{r.class}:#{r.id}') OR (#{attr_name} LIKE '#{r.class}:#{r.id},%') OR (#{attr_name} LIKE '%,#{r.class}:#{r.id},%') OR (#{attr_name} LIKE '%,#{r.class}:#{r.id}')")
					}
				else
					scope "with_#{attr_name}_containing", lambda {|r|
						where("(#{attr_name} = '#{r.id}') OR (#{attr_name} LIKE '#{r.id},%') OR (#{attr_name} LIKE '%,#{r.id},%') OR (#{attr_name} LIKE '%,#{r.id}')")
					}
				end
			end
	
		end
	
	end
	
end
