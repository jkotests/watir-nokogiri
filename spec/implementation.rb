require_relative '..\lib\watir-nokogiri'
require 'rspec/autorun' # Added so that specs can be run individually from SciTE

WatirSpec.implementation do |imp|
	imp.name = :watir_nokogiri

	WatirSpec.persistent_browser = false
	imp.browser_class = WatirNokogiri::Document

	imp.guard_proc = lambda { |args|
		args.any? {|arg| arg == :watir_nokogiri }
	}
end

include WatirNokogiri
include WatirNokogiri::Exception


module WatirSpec
	class << self
		def files
			@files ||= html
		end
	end
end