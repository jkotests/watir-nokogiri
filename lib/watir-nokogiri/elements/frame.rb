# encoding: utf-8
module WatirNokogiri
  class Frame < HTMLElement

    def locate
      @parent.assert_exists

      element = locate_iframe || locate_frame
      element or raise UnknownFrameException, "unable to locate frame/iframe using #{@selector.inspect}"
    end

    def assert_exists
      if @selector.has_key? :element
        raise UnknownFrameException, "wrapping a Nokogiri element as a Frame is not currently supported"
      end

      super
    end

    def html
      assert_exists

      # this will actually give us the innerHTML instead of the outerHTML of the <frame>,
      # but given the choice this seems more useful
      execute_atom(:getOuterHtml, @element.find_element(:tag_name => "html")).strip
    end

    def execute_script(*args)
      browser.execute_script(*args)
    end

    private

    def locate_iframe
      locator = locator_class.new(@parent.nokogiri, @selector.merge(:tag_name => "iframe"), attribute_list)
      locator.locate
    end

    def locate_frame
      locator = locator_class.new(@parent.nokogiri, @selector.merge(:tag_name => "frame"), attribute_list)
      locator.locate
    end

    def attribute_list
      self.class.attribute_list | IFrame.attribute_list
    end
  end # Frame

  module Container
    def frame(*args)
      Frame.new(self, extract_selector(args))
    end

    def frames(*args)
      FrameCollection.new(self, extract_selector(args).merge(:tag_name => /^(iframe|frame)$/)) # hack
    end

    def iframe(*args)
      warn "WatirNokogiri::Container#iframe is replaced by WatirNokogiri::Container#frame"
      frame(*args)
    end

    def iframes(*args)
      warn "WatirNokogiri::Container#iframes is replaced by WatirNokogiri::Container#frames"
      frame(*args)
    end
  end

  class FrameCollection < ElementCollection
    def to_a
      (0...elements.size).map { |idx| element_class.new @parent, :index => idx }
    end
  end

end # WatirNokogiri
