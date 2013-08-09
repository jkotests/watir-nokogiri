# encoding: utf-8
module WatirNokogiri
  class Select < HTMLElement
    include WatirNokogiri::Exception

    #
    # Returns true if this element is enabled
    #
    # @return [Boolean]
    #

    def enabled?
      !disabled?
    end

    #
    # Clears all selected options.
    #

    def clear
      assert_exists
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    #
    # Gets all the options in the select list
    #
    # @return [Watir::OptionCollection]
    #

    def options
      assert_exists
      super
    end

    #
    # Returns true if the select list has one or more options where text or label matches the given value.
    #
    # @param [String, Regexp] str_or_rx
    # @return [Boolean]
    #

    def include?(str_or_rx)
      assert_exists
      # TODO: optimize similar to selected?
      options.any? { |e| str_or_rx === e.text }
    end

    #
    # Select the option(s) whose text or label matches the given string.
    # If this is a multi-select and several options match the value given, all will be selected.
    #
    # @param [String, Regexp] str_or_rx
    # @raise [Watir::Exception::NoValueFoundException] if the value does not exist.
    # @return [String] The text of the option selected. If multiple options match, returns the first match.
    #

    def select(str_or_rx)
      assert_exists
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    #
    # Selects the option(s) whose value attribute matches the given string.
    #
    # @see +select+
    #
    # @param [String, Regexp] str_or_rx
    # @raise [Watir::Exception::NoValueFoundException] if the value does not exist.
    # @return [String] The option selected. If multiple options match, returns the first match
    #

    def select_value(str_or_rx)
      assert_exists
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    #
    # Returns true if any of the selected options' text or label matches the given value.
    #
    # @param [String, Regexp] str_or_rx
    # @raise [Watir::Exception::UnknownObjectException] if the options do not exist
    # @return [Boolean]
    #

    def selected?(str_or_rx)
      assert_exists
      matches = options.select { |e| str_or_rx === e.text || str_or_rx === e.attribute_value(:label) }

      if matches.empty?
        raise UnknownObjectException, "Unable to locate option matching #{str_or_rx.inspect}"
      end

      matches.any? { |e| e.selected? }
    end

    #
    # Returns the value of the first selected option in the select list.
    # Returns nil if no option is selected.
    #
    # @return [String, nil]
    #

    def value
      o = options.find { |e| e.selected? } || return
      o.value
    end

    #
    # Returns an array of currently selected options.
    #
    # @return [Array<Watir::Option>]
    #

    def selected_options
      assert_exists
      options.select { |e| e.selected? }
    end

  end # Select

  module Container
    alias_method :select_list,  :select
    alias_method :select_lists, :selects
  end # Container
end # Watir
