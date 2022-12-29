require 'minitest/autorun'
require './parser'

class TestParser < Minitest::Test

  TEST_HTML = '<div id="foo"><div id=bar>test</div></div>'

  def test_to_array
    items = Parser.to_array(TEST_HTML).compact
    assert_equal(2, items.length)
  end

  def test_html_elements
    html = Nokogiri::HTML(TEST_HTML)
    items = Parser.html_elements(html).compact
    assert_equal(4, items.length)
  end

  def test_element_to_hash
    html = Nokogiri::HTML('<div id="foo">bar</div>')
    items = Parser.html_elements(html).compact
    item = Parser.element_to_hash(items[2])
    assert_equal('foo', item[:id])
    assert_equal('bar', item[:text])
  end

  def test_index
    items = [ { foo: 'bar' }, { foo: 'baz' }]
    result = Parser.index(items, {foo: 'bar'})
    assert_equal( 0, result)
  end

  def test_filter
    items = [ { foo: 'bar' }, { foo: 'baz' }]
    result = Parser.filter(items, {foo: 'bar'})
    assert_equal( [{foo: 'bar'}], result)
  end

  def test_chunk
    items = [0,1,2,3,4,5,6,7,8]
    result = Parser.chunk(items, 3)
    assert_equal(3, result.length)
    result.map { |i| assert_equal(3, i.length)}
  end
end

