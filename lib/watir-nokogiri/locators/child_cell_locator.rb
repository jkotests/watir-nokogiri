module WatirNokogiri
  class ChildCellLocator < ElementLocator

    private
    
    def build_nokogiri_selector(selectors)
      return if selectors.values.any? { |e| e.kind_of? Regexp }

      expressions = %w[./th ./td]
      attr_expr = attribute_expression(selectors)

      unless attr_expr.empty?
        expressions.map! { |e| "#{e}[#{attr_expr}]" }
      end

      xpath = expressions.join(" | ")

      p :build_nokogiri_selector => xpath if $DEBUG

      [:xpath, xpath]
    end

  end # ChildCellLocator
end # WatirNokogiri
