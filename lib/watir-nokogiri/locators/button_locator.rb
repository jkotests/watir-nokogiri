module WatirNokogiri
  class ButtonLocator < ElementLocator

    def build_nokogiri_selector(selectors)
      return if selectors.values.any? { |e| e.kind_of? Regexp }

      selectors.delete(:tag_name) || raise("internal error: no tag_name?!")

      @building = :button
      button_attr_exp = attribute_expression(selectors)

      @building = :input
      selectors[:type] = Button::VALID_TYPES
      input_attr_exp = attribute_expression(selectors)

      xpath = ".//button"
      xpath << "[#{button_attr_exp}]" unless button_attr_exp.empty?
      xpath << " | .//input"
      xpath << "[#{input_attr_exp}]"

      p :build_nokogiri_selector => xpath if $DEBUG

      [:xpath, xpath]
    end

    def lhs_for(key)
      if @building == :input && key == :text
        "@value"
      else
        super
      end
    end

    def equal_pair(key, value)
      if @building == :button && key == :value
        # :value should look for both node text and @value attribute
        text = XpathSupport.escape(value)
        "(text()=#{text} or @value=#{text})"
      else
        super
      end
    end

    def tag_name_matches?(tag_name, _)
      !!(/^(input|button)$/ === tag_name)
    end

    def validate_element(element)
      return if element.node_name.downcase == "input" && !Button::VALID_TYPES.include?(element.get_attribute(:type).downcase)
      super
    end

  end # ButtonLocator
end # WatirNokogiri
