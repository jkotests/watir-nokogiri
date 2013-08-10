Watir-Nokogiri
==============

Watir-Nokogiri is an HTML parser using Watir's API.

Background
-----------

Watir (classic and webdriver) can have performance issues when parsing large HTML pages. One solution has been to extract the page's HTML using Watir and then parse the HTML with an HTML parser (ex Nokogiri). This required learning two APIs - Watir and the HTML parser. Watir-Nokogiri eliminates the need to learn an HTML parser API by applying the Watir API to the HTML parser Nokogiri.

Usage
-----------

Watir-Nokogiri can parse a string containing HTML.

This is typically supplied by a Watir browser:

```ruby
doc = WatirNokogiri::Document.new(browser.html)
```

However, you can also read from a file:

```ruby
doc = WatirNokogiri::Document.start('C:\some_file.html')
```

With the parsed document, you can use the standard Watir API to locate elements and validate text/attributes.

Check if an element exists

```ruby
doc.div(:id => 'my_id').exists?
```

Get the text of an element

```ruby
doc.span(:id => 'my_span').text
```

Get an attribute value of an element

```ruby
doc.span(:id => 'my_span').attribute_value('name')
```

Count the number of elements

```ruby
doc.text_fields.length
```