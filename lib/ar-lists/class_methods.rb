# CURRENT FILE :: lib/ar-lists/engine.rb
module ArLists

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods
    
		def array_accessible(attr_name, options = {})
			do_uniq = false || options[:uniq]
			attr_accessible attr_name
			define_method "#{attr_name}=" do |values|
				val = [values].flatten.map{|v| v.to_s.split(',')}.flatten.reject{|v| v.blank?}
				val.uniq! if do_uniq
				write_attribute attr_name, val.join(',')
			end
			define_method "#{attr_name}" do
				val = read_attribute attr_name
				val.blank? ? [] : val.split(',')
			end
		end

		def has_list(attr_name, options = {})
			do_uniq = false || options[:uniq]
			strict = false || options[:strict]
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
			define_method "#{attr_name}=" do |records|
				val = records.map{|r| r.id.to_s}
				val.uniq! if do_uniq
				write_attribute attr_name, val.join(',')
			end
			define_method "#{attr_name}" do
				val = read_attribute attr_name
				val.blank? ? [] : val.split(',').map{|id|
					begin
						class_name.constantize.find(id)
					rescue RecordNotFound
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
