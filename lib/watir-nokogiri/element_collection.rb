module WatirNokogiri

  #
  # Base class for element collections.
  #

  class ElementCollection   
    include Enumerable
     
    def initialize(parent, selector)
      @parent = parent
      @selector = selector
    end       
     
    #
    # Yields each element in collection.
    #
    # @yieldparam [WatirNokogiri::Element] element Iterate through the elements in this collection.
    #	
    
    def each(&blk)
      to_a.each(&blk)
    end
    
    #
    # Returns number of elements in collection.
    #
    # @return [Fixnum]
    #

    def length
      elements.length
    end
    alias_method :size, :length

    #
    # Get the element at the given index.
    # Note that this is 0-indexed.
    #
    # @param [Fixnum] idx Index of wanted element, 0-indexed
    # @return [WatirNokogiri::Element] Returns an instance of a WatirNokogiri::Element subclass
    #

    def [](idx)
      to_a[idx] || element_class.new(@parent, :index => idx)
    end

    #
    # First element of this collection
    #
    # @return [WatirNokogiri::Element] Returns an instance of a WatirNokogiri::Element subclass
    #

    def first
      self[0]
    end

    #
    # Last element of the collection
    #
    # @return [WatirNokogiri::Element] Returns an instance of a WatirNokogiri::Element subclass
    #

    def last
      self[-1]
    end
    
    #
    # This collection as an Array.
    #
    # @return [Array<WatirNokogiri::Element>]
    #		

    def to_a()
      @to_a ||= elements.map{ |e| element_class.new(@parent, :element => e) }
    end

    private
    
    def elements()
      @elements ||= locator_class.new(@parent.nokogiri, @selector, element_class.attribute_list).locate_all
    end

    def element_class()
      Element
    end
  
    def locator_class()
      ElementLocator
    end
  
  end   
end