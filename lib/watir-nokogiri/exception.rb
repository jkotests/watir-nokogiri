# encoding: utf-8

module WatirNokogiri
	module Exception
		class Error < StandardError; end
		
		class UnknownObjectException < Error; end
		class ObjectDisabledException < Error; end
		class ObjectReadOnlyException < Error; end
		class NoValueFoundException < Error; end
		class MissingWayOfFindingObjectException < Error; end
		class UnknownCellException < Error; end
		class NoMatchingWindowFoundException < Error; end
		class NoStatusBarException < Error; end
		class NavigationException < Error; end
		class UnknownFrameException < Error; end
		class UnknownRowException < Error; end
	
	end # Exception
end # WatirNokogiri