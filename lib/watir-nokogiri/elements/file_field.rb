# encoding: utf-8
module WatirNokogiri
	class FileField < Input

		#
		# Set the file field to the given path
		#
		# @param [String] a path
		# @raise [Errno::ENOENT] if the file doesn't exist
		#

		def set(path)
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

		#
		# Sets the file field to the given path
		#
		# @param [String] path
		#

		def value=(path)
			assert_exists
			raise NotImplementedError, "not currently supported by WatirNokogiri"
		end

	end # FileField

	module Container
		def file_field(*args)
			FileField.new(self, extract_selector(args).merge(:tag_name => "input", :type => "file"))
		end

		def file_fields(*args)
			FileFieldCollection.new(self, extract_selector(args).merge(:tag_name => "input", :type => "file"))
		end
	end # Container

	class FileFieldCollection < InputCollection
		def element_class
			FileField
		end
	end # FileFieldCollection
end # WatirNokogiri