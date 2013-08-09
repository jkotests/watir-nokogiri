# encoding: utf-8

module WatirNokogiri

	#
	# Base class for HTML elements.
	#

	class Element
		extend AttributeHelper
		
		include Exception
		include Container
		
		attributes :string => [:id, :class_name]
		 
		def initialize(parent, selector)
			@parent = parent
			@selector = selector
			@element = nil
			
			unless @selector.kind_of? Hash
				raise ArgumentError, "invalid argument: #{selector.inspect}"
			end			
		end

		#
		# Returns true if two elements are equal.
		#
		# @example
		#   html.a(:id => "foo") == html.a(:id => "foo")
		#   #=> true
		#

		def ==(other)
			return false unless other.kind_of? self.class

			assert_exists
			@element == other.nokogiri
		end
		alias_method :eql?, :==

		#
		# Returns given attribute value of element.
		#
		# @example
		# html.a(:id => "foo").attribute_value "href"
		# #=> "http://watir.com"
		#
		# @param [String] attribute_name
		# @return [String]
		#

		def attribute_value(attribute_name)
			assert_exists
			@element.get_attribute(attribute_name) || ''
		end

    def click(*modifiers)
      assert_exists
      raise "Not implemented"
    end

		#
		# @api private
		#

		def document
			@parent.document
		end

		#
		# @api private
		#

		def driver
			@parent.driver
		end

		#
		# Returns true if element exists.
		#
		# @return [Boolean]
		#

		def exists?()
			begin
				assert_exists
				return true
			rescue UnknownObjectException, UnknownFrameException
				return false
			end
		end
		alias_method :exist?, :exists?

		#
		# Returns outer (inner + element itself) HTML code of element.
		#
		# @example
		# html.div(:id => "foo").html
		# #=> "<div id=\"foo\"><a>Click</a></div>"
		#
		# @return [String]
		#

		def html
			assert_exists
			@element.to_html
		end

		def id()
			assert_exists
			attribute_value('id')
		end

		def inspect()
			if @selector.has_key?(:element)
				'#<%s:0x%x located=%s selector=%s>' % [self.class, hash*2, !!@element, '{:element=>(nokogiri element)}']
			else
				'#<%s:0x%x located=%s selector=%s>' % [self.class, hash*2, !!@element, @selector.inspect]
			end
		end

		#
		# @api private
		#

		def nokogiri()
			assert_exists
			@element
		end

		#
		# Returns given style property of this element.
		#
		# @example
		# html.a(:id => "foo").style
		# #=> "display: block"
		# html.a(:id => "foo").style "display"
		# #=> "block"
		#
		# @param [String] property
		# @return [String]
		#

		def style(property = nil)
			assert_exists
			styles = attribute_value('style').to_s.strip
			if property
				properties = Hash[styles.downcase.split(";").map { |p| p.split(":").map(&:strip) }]
				properties[property]				
			else
				styles
			end
		end

		#
		# Returns parent element of current element.
		#

		def parent
			assert_exists

      e = @element.parent

      if e.kind_of?(Nokogiri::XML::Element)
        WatirNokogiri.element_class_for(e.node_name.downcase).new(@parent, :element => e)
      end
		end

    #
    # Returns true if the element exists and is visible on the page.
    #
    # @return [Boolean]
    #

    def present?
			assert_exists
			raise "Not implemented"
    end

		#
		# Returns tag name of the element.
		#
		# @return [String]
		#

		def tag_name
			assert_exists
			@element.node_name.downcase
		end

		#
		# Returns the text of the element.
		#
		# @return [String]
		#

		def text()
			assert_exists
			@element.text.strip
		end   

    #
    # Cast this Element instance to a more specific subtype.
    #
    # @example
    #   browser.element(:xpath => "//input[@type='submit']").to_subtype
    #   #=> #<WatirNokogiri::Button>
    #

    def to_subtype
      elem = nokogiri()
      tag_name = elem.node_name.downcase

      klass = nil

      if tag_name == "input"
        klass = case elem.get_attribute(:type)
          when *Button::VALID_TYPES
            Button
          when 'checkbox'
            CheckBox
          when 'radio'
            Radio
          when 'file'
            FileField
          else
            TextField
          end
      else
        klass = WatirNokogiri.element_class_for(tag_name)
      end

      klass.new(@parent, :element => elem)
    end

		#
		# Returns value of the element.
		#
		# @return [String]
		#

		def value
			assert_exists
			attribute_value('value')
		end

    #
    # Returns true if this element is visible on the page.
    #
    # @return [Boolean]
    #

    def visible?
      assert_exists
      raise "Not implemented"
    end
    
		#
		# Returns the xpath of the current element.
		#

		def xpath()
			assert_exists
			@element.path
		end		

		protected
		
		def assert_exists()
			return if @element
			 
			@element = @selector[:element] || locate
			 
			unless @element
				raise UnknownObjectException, "unable to locate element, using #{@selector.inspect}"
			end
		end   

		def locate
			@parent.assert_exists
			locator_class.new(@parent.nokogiri, @selector, self.class.attribute_list).locate
		end

		private

    #
    # Returns attribute value if attribute exists; nil otherwise
    #
    def attribute?(attribute)
      assert_exists
      @element.get_attribute(attribute.to_s.downcase)
    end
  
		def locator_class
			ElementLocator
		end    

		def method_missing(meth, *args, &blk)
			method = meth.to_s
			if method =~ /^data_(.+)$/
				attribute_value(method.gsub(/_/, '-'), *args)
			else
				super
			end
		end
	end
	 
end