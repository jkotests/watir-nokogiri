module WatirNokogiri
	class ChildRowLocator < ElementLocator

		private

		def build_nokogiri_selector(selectors)
			return if selectors.values.any? { |e| e.kind_of? Regexp }
			selectors.delete(:tag_name) || raise("internal error: no tag_name?!")

			expressions = %w[./tr]
			unless %w[tbody tfoot thead].include?(@nokogiri.node_name.downcase)
				expressions += %w[./tbody/tr ./thead/tr ./tfoot/tr]
			end

			attr_expr = attribute_expression(selectors)

			unless attr_expr.empty?
				expressions.map! { |e| "#{e}[#{attr_expr}]" }
			end

			xpath = expressions.join(" | ")

			p :build_nokogiri_selector => xpath if $DEBUG

			[:xpath, xpath]
		end

	end # ChildRowLocator
end # WatirNokogiri
