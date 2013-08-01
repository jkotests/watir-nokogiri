# encoding: utf-8
module WatirNokogiri
	class Image < HTMLElement

    #
    # Returns true if image is loaded.
    #
    # @return [Boolean]
    #

    def loaded?
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

		#
		# Returns the image's width in pixels.
		#
		# @return [Fixnum] width
		#

		def width
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		#
		# Returns the image's height in pixels.
		#
		# @return [Fixnum] width
		#

		def height
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		def file_created_date
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		def file_size
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		def save(path)
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

	end # Image

	module Container
		 alias_method :image, :img
		 alias_method :images, :imgs
	end # Container
end # WatirNokogiri
