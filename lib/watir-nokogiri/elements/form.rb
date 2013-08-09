# encoding: utf-8
module WatirNokogiri
  class Form < HTMLElement

    #
    # Submits the form.
    #
    # This method should be avoided - invoke the user interface element that triggers the submit instead.
    #

    def submit
      assert_exists
      raise NotImplementedError, "not currently supported by WatirNokogiri"
    end

  end # Form
end # WatirNokogiri
