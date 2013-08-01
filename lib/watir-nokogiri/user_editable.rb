module WatirNokogiri
	module UserEditable

		#
		# Clear the element, the type in the given value.
		#
		# @param [String, Symbol] *args
		#

		def set(*args)
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end
		alias_method :value=, :set

		#
		# Appends the given value to the text in the text field.
		#
		# @param [String, Symbol] *args
		#

		def append(*args)
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end
		alias_method :<<, :append

		#
		# Clears the text field.
		#

		def clear
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

	end # UserEditable
end # WatirNokogiri
