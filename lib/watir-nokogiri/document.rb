# encoding: utf-8
module WatirNokogiri

  #
  # The main class through which you control the html.
  #

  class Document
    include Container

    attr_reader :driver
    alias_method :nokogiri, :driver # ensures duck typing with WatirNokogiri::Element

    class << self
      def start(file_path)
        b = new()
        b.goto file_path

        b
      end
    end

    #
    # Creates a WatirNokogiri::HTML instance.
    #

    def initialize(html = '')
      @driver = Nokogiri::HTML.parse(html)
    end

    def inspect
      '#<%s:0x%x>' % [self.class, hash*2]
    rescue
      '#<%s:0x%x closed=%s>' % [self.class, hash*2, exist?.to_s]
    end

    #
    # Reads the given file as HTML.
    #
    # @example
    #   browser.goto "www.google.com"
    #
    # @param [String] uri The url.
    # @return [String] The url you end up at.
    #

    def goto(file_path)
      html = File.read(file_path)
      @driver = Nokogiri::HTML.parse(html)
    end

    def back
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def forward
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def url
      assert_exists
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def title
      @driver.title
    end

    def close
      @driver = nil
    end
    alias_method :quit, :close # TODO: close vs quit

    def cookies
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def name
      :nokogiri
    end

    #
    # Returns text of page body.
    #
    # @return [String]
    #

    def text
      @driver.at_css('body').text
    end

    #
    # Returns HTML code of current page.
    #
    # @return [String]
    #

    def html
      # use body.html instead?
      @driver.at_css('html').to_html
    end

    def alert
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def refresh
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def wait(timeout = 5)
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def ready_state
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def status
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def execute_script(script, *args)
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def send_keys(*args)
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def screenshot
      Screenshot.new driver
    end

    def add_checker(checker = nil, &block)
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def disable_checker(checker)
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    def run_checkers
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

    #
    # Returns true if html has been supplied and false otherwise.
    #
    # @return [Boolean]
    #

    def exist?
      !@driver.nil?
    end
    alias_method :exists?, :exist?

    def assert_exists
        true
    end

    def reset!
      # no-op
    end

    def document
      self
    end

  end # Document
end # WatirNokogiri