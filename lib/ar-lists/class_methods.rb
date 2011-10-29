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
    
  end

end

class ActiveRecord::Base
  include ArLists
end
