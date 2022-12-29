require 'nokogiri'
require 'json'

module Parser
  # Convert to an array of hashes.
  def self.to_array(html=nil)
    return if html.nil?
    tmp = html
    tmp = Nokogiri::HTML(html) if html.is_a?(String)
    elements = Parser.html_elements(tmp)
    result = []
    elements.map { |elmnt| result << Parser.element_to_hash(elmnt) }
    result 
  end

  # Recurse through the elements and return an array of elements.
  def self.html_elements(html=[])
    return if html.nil?
    items = [*html.elements]
    html.elements.map { |element| items += Parser.html_elements(element) }
    items
  end

  # Convert a Nokogiri Element into a hash.
  def self.element_to_hash(element)
    return if element.nil?
    nodes = element.attribute_nodes
    return if nodes.empty?
    item = {element: element.name} 
    nodes.map { |node|
      item[node.name.to_sym] = node.value unless node.name.nil? 
      item[:text]= element.text unless element.text.nil? || element.text.empty?
    }
    item
  end

  # Divide the given items into arrays 
  def self.chunk(items=[], size=0)
    return if items.nil? || items.empty?
    return if size == 0
    result = []
    index = 0
    while index < items.length
      result << items.slice(index, size)
      index += size
    end
    result
  end

  # Return all items matching the given filter.
  def self.filter(items=[], filter={})
    return if items.nil? || items.empty?
    return if filter.nil? || filter.empty?
    items.select { |item| (filter.to_a - item.to_a).empty? }
  end

  # Return the index of the first item matching the given filter.
  def self.index(items=[], filter={})
    return if items.nil? || items.empty?
    return if filter.nil? || filter.empty?
    items.index{ |item| (filter.to_a - item.to_a).empty? }
  end
  
end
