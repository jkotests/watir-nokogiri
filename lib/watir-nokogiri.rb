# encoding: utf-8
require 'nokogiri'

require_relative 'watir-nokogiri/version'
require_relative 'watir-nokogiri/exception'
require_relative 'watir-nokogiri/xpath_support'
require_relative 'watir-nokogiri/container'
require_relative 'watir-nokogiri/locators/element_locator'
require_relative 'watir-nokogiri/locators/button_locator'
require_relative 'watir-nokogiri/locators/text_area_locator'
require_relative 'watir-nokogiri/locators/text_field_locator'
require_relative 'watir-nokogiri/locators/child_row_locator'
require_relative 'watir-nokogiri/locators/child_cell_locator'
require_relative 'watir-nokogiri/document'

module WatirNokogiri
  class << self

    #
    # @api private
    #

    def tag_to_class
      @tag_to_class ||= {}
    end

    #
    # @api private
    #

    def element_class_for(tag_name)
      tag_to_class[tag_name.to_sym] || HTMLElement
    end
    
  end
end #WatirNokogiri

require_relative 'watir-nokogiri/attribute_helper'
require_relative 'watir-nokogiri/row_container'
require_relative 'watir-nokogiri/cell_container'
require_relative 'watir-nokogiri/user_editable'
require_relative 'watir-nokogiri/element_collection'
require_relative 'watir-nokogiri/elements/element'
require_relative 'watir-nokogiri/elements/generated'

require_relative 'watir-nokogiri/elements/button'
require_relative 'watir-nokogiri/elements/checkbox'
require_relative 'watir-nokogiri/elements/dlist'
require_relative 'watir-nokogiri/elements/file_field'
require_relative 'watir-nokogiri/elements/font'
require_relative 'watir-nokogiri/elements/form'
require_relative 'watir-nokogiri/elements/hidden'
require_relative 'watir-nokogiri/elements/image'
require_relative 'watir-nokogiri/elements/input'
require_relative 'watir-nokogiri/elements/link'
require_relative 'watir-nokogiri/elements/option'
require_relative 'watir-nokogiri/elements/radio'
require_relative 'watir-nokogiri/elements/select'
require_relative 'watir-nokogiri/elements/table'
require_relative 'watir-nokogiri/elements/table_cell'
require_relative 'watir-nokogiri/elements/table_row'
require_relative 'watir-nokogiri/elements/table_section'
require_relative 'watir-nokogiri/elements/text_area'
require_relative 'watir-nokogiri/elements/text_field'

require_relative 'watir-nokogiri/aliases'

WatirNokogiri.tag_to_class.freeze
