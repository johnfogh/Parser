# Parser
One of the issues with some webscraping tools is the dependency upon navigating the HTML heirarchy. Normally this is done with an xpath or css in Nokogiri. The issue is that getting to the actual data can be callenging and might require a significant amount of logic at each step of the process: find a wrapper element, find a data element within that wrapper, get an attribute from that data element, etc. This can be compliated if elements don't have identifiable class names or ids. Some page designs (speciifcally those using HTML tables) do not consistenly represent the data within the disign (A1 is a label, B1 is data, but A2 is a label and A3 is data.)

The way this parser works is it flattens the heirarchy into a flat, one-dimensional array of hashes, with each hash holding the properties of the original nokogiri element. This array can then be sliced, truncated, or filtered to remove any elements we don't care about. The remaining elements can then be 'chunked' into multi-dimensinoal array and each chunk can then be processed for the data that we are looking for.

# Testing
``` ruby
  ruby test_parser.rb
```
# Example
```ruby
  ruby example.rb
```

This will produce './data.json' containing a JSON array of objects: { title, url, username }
