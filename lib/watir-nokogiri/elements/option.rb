# encoding: utf-8
module WatirNokogiri

	#
	# Represents an option in a select list.
	#

	class Option < HTMLElement

		#
		# Selects this option.
		#
		# @example
		#   browser.select(:id => "foo").options.first.select
		#

		def select
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		#
		# Toggles the selected state of this option.
		#
		# @example
		#   browser.select(:id => "foo").options.first.toggle
		#

		def toggle
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		#
		# Clears (i.e. toggles selected state) option.
		#
		# @example
		#   browser.select(:id => "foo").options.first.clear
		#

		def clear
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		#
		# Is this option selected?
		#
		# @return [Boolean]
		#

		def selected?
			assert_exists
			@element.selected?
		end

		#
		# Returns the text of option.
		#
		# Note that the text is either one of the following respectively:
		#   * label attribute
		#   * text attribute
		#   * inner element text
		#
		# @return [String]
		#

		def text
			assert_exists

			# A little unintuitive - we'll return the 'label' or 'text' attribute if
			# they exist, otherwise the inner text of the element

			attribute = [:label, :text].find { |a| attribute? a }

			if attribute
				@element.get_attribute(attribute)
			else
				@element.text
			end
		end

	end # Option
end # WatirNokogiri
