# encoding: utf-8
module WatirNokogiri
	class ElementLocator
		include WatirNokogiri::Exception
		
		def initialize(nokogiri, selector, valid_attributes)
			@nokogiri = nokogiri
			@selector = selector.dup
			@valid_attributes = valid_attributes
		end
		 
		def locate()	
			idx = @selector.delete(:index)
			if idx
				locate_all[idx]
			else
				locate_all.first
			end
		end

		def locate_all()
			selector = normalized_selector
			
			if selector.has_key? :index
				raise ArgumentError, "can't locate all elements by :index"
			end

			how, what = given_xpath(selector) || build_nokogiri_selector(selector)
			if how
				@nokogiri.xpath(what)
			else
				find_by_regexp_selector(selector, :select)
			end				
		end
				
		def find_by_regexp_selector(selector, method = :find)
			parent = @nokogiri
			rx_selector = delete_regexps_from(selector)

			if rx_selector.has_key?(:label) && should_use_label_element?
				label = label_from_text(rx_selector.delete(:label)) || return
				if (id = label.get_attribute('for'))
					selector[:id] = id
				else
					parent = label
				end
			end

			how, what = build_nokogiri_selector(selector)

			unless how
				raise Error, "internal error: unable to build WebDriver selector from #{selector.inspect}"
			end

			elements = parent.xpath(what)
			elements.__send__(method) { |el| matches_selector?(el, rx_selector) }
		end

		def delete_regexps_from(selector)
			rx_selector = {}

			selector.dup.each do |how, what|
			next unless what.kind_of?(Regexp)
				rx_selector[how] = what
				selector.delete how
			end

			rx_selector
		end			

		def assert_valid_as_attribute(attribute)
			unless valid_attribute? attribute or attribute.to_s =~ /^data_.+$/
				raise MissingWayOfFindingObjectException, "invalid attribute: #{attribute.inspect}"
			end
		end

		def valid_attribute?(attribute)
			@valid_attributes && @valid_attributes.include?(attribute)
		end

		def should_use_label_element?
			@selector[:tag_name] != "option"
		end

		def label_from_text(label_exp)
			# TODO: this won't work correctly if @nokogiri is a sub-element
			@nokogiri.search('label').find do |el|
				matches_selector?(el, :text => label_exp)
			end
		end
		
		def matches_selector?(element, selector)
			selector.all? do |how, what|
				what === fetch_value(element, how)
			end
		end

		def fetch_value(element, how)
			case how
			when :text
				element.text
			when :tag_name
				element.node_name.downcase
			when :href
				(href = element.get_attribute('href')) && href.strip
			else
				element.get_attribute(how.to_s.gsub("_", "-"))
			end
		end

		def normalized_selector
			selector = {}

			@selector.each do |how, what|
				check_type(how, what)

				how, what = normalize_selector(how, what)
				selector[how] = what
			end

			selector
		end

		def normalize_selector(how, what)
			case how
			when :tag_name, :text, :xpath, :index, :class, :label
				# include :class since the valid attribute is 'class_name'
				# include :for since the valid attribute is 'html_for'
				[how, what]
			when :class_name
				[:class, what]
			when :caption
				[:text, what]
			when :for
				assert_valid_as_attribute :html_for
				[how, what]
			else
				assert_valid_as_attribute how
				[how, what]
			end
		end


		VALID_WHATS = [String, Regexp]

		def check_type(how, what)
			case how
			when :index
				unless what.kind_of?(Fixnum)
					raise TypeError, "expected Fixnum, got #{what.inspect}:#{what.class}"
				end
			else
				unless VALID_WHATS.any? { |t| what.kind_of? t }
					raise TypeError, "expected one of #{VALID_WHATS.inspect}, got #{what.inspect}:#{what.class}"
				end
			end
		end
			
		def given_xpath(selector)
			return unless xpath = selector.delete(:xpath)

			unless selector.empty? || can_be_combined_with_xpath?(selector)
				raise ArgumentError, ":xpath cannot be combined with other selectors (#{selector.inspect})"
			end

			[:xpath, xpath]
		end

		def can_be_combined_with_xpath?(selector)
			# ouch - is this worth it?
			keys = selector.keys
			return true if keys == [:tag_name]

			if selector[:tag_name] == "input"
				return keys == [:tag_name, :type] || keys == [:type, :tag_name]
			end

			false
		end

		def build_nokogiri_selector(selectors)
			unless selectors.values.any? { |e| e.kind_of? Regexp }
				build_xpath(selectors)
			end
		end
		
		def build_xpath(selectors)
			xpath = ".//"
			xpath << (selectors.delete(:tag_name) || '*').to_s

			idx = selectors.delete :index

			# the remaining entries should be attributes
			unless selectors.empty?
				xpath << "[" << attribute_expression(selectors) << "]"
			end

			if idx
				xpath << "[#{idx + 1}]"
			end

			p :xpath => xpath, :selectors => selectors if $DEBUG

			[:xpath, xpath]
		end		

		def attribute_expression(selectors)
			selectors.map do |key, val|
				if val.kind_of?(Array)
					"(" + val.map { |v| equal_pair(key, v) }.join(" or ") + ")"
				else
					equal_pair(key, val)
				end
			end.join(" and ")
		end

		def equal_pair(key, value)
			if key == :class
				klass = XpathSupport.escape " #{value} "
				"contains(concat(' ', @class, ' '), #{klass})"
			elsif key == :label && should_use_label_element?
				# we assume :label means a corresponding label element, not the attribute
				text = "normalize-space()=#{XpathSupport.escape value}"
				"(@id=//label[#{text}]/@for or parent::label[#{text}])"
			else
				"#{lhs_for(key)}=#{XpathSupport.escape value}"
			end
		end

		def lhs_for(key)
			case key
			when :text, 'text'
				'normalize-space()'
			when :href
				# TODO: change this behaviour?
				'normalize-space(@href)'
			when :type
				# type attributes can be upper case - downcase them
				# https://github.com/watir/watir-webdriver/issues/72
				XpathSupport.downcase('@type')
			else
				"@#{key.to_s.gsub("_", "-")}"
			end
		end

	end # ElementLocator
end # WatirNokogiri