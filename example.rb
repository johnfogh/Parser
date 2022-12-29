require 'open-uri'
require './parser'
require 'json'

URL = 'https://thepiratebay.gg/top.php'

# load the html page.
html = URI.parse(URL).read

# Convert to items.
items = Parser.to_array(html).compact

# Discard HTML elements we don't care about.
discard_html_tags = %w[
  html body meta link script header img section
  form input li span label font footer div ol
]
items = items.reject{ |item| discard_html_tags.include?(item[:element]) }

# Discard items with hrefs we don't care about,
discard_hrefs = [
  '/category.php', 'https://vpnoffers.org', '/index.php',
  '/browse.php', '/recent.php', '/top.php',
  'https://piratebay.fun', "https://pirates-forum.org/",
  "http://piratebayztemzmv.onion"
]
discard_hrefs.map { |discard| 
  items = items.reject{ |item| item[:href].include?(discard) }
}

# Now we can make a record of every 3 rows of the remaining items:
# the item title, the torrent link, and the username.
chunks = Parser.chunk(items, 3)
results = []  
chunks.map { |chunk| 
  results << {
    title: chunk[0][:text],
    link: chunk[1][:href],
    user: chunk[2][:text]
  }
}

# Write output to a file.
File.write("./data.json", JSON.pretty_generate(results))
