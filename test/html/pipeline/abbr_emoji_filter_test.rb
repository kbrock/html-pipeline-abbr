require 'minitest_helper'
require 'byebug'

class Html::Pipeline::AbbrEmojiFilterTest < Minitest::Test
  AbbrEmojiFilter = HTML::Pipeline::AbbrEmojiFilter

  def test_no_change
    result = html_from_fragment("<p>No Emoji Here</p>")
    assert_equal %(<p>No Emoji Here</p>), result
  end

  def test_emojify
    filter = AbbrEmojiFilter.new("<p>:shipit:</p>", {:asset_root => 'https://foo.com'})
    doc = filter.call
    assert_match "https://foo.com/emoji/shipit.png", doc.search('img').attr('src').value
  end

  def test_uri_encoding
    doc = doc_from_fragment("<p>:+1:</p>")
    assert_match "https://foo.com/emoji/unicode/1f44d.png", doc.search('img').attr('src').value
  end

  def test_required_context_validation
    exception = assert_raises(ArgumentError) {
      AbbrEmojiFilter.call("", {})
    }
    assert_match(/:asset_root/, exception.message)
  end

  def test_custom_asset_path
    doc = doc_from_fragment("<p>:+1:</p>", {:asset_path => ':file_name', :asset_root => 'https://foo.com'})
    assert_match "https://foo.com/unicode/1f44d.png", doc.search('img').attr('src').value
  end

  def test_not_emojify_in_code_tags
    body = "<code>:shipit:</code>"
    html = html_from_fragment(body)
    assert_equal body, html
  end

  def test_not_emojify_in_pre_tags
    body = "<pre>:shipit:</pre>"
    html = html_from_fragment(body)
    assert_equal body, html
  end

  def test_unicode_emojify_for_unknown_in_svg_tags
    body = "<svg><text>:shipit:</text></svg>"
    html = html_from_fragment(body)
    assert_equal "<svg><text>shipit</text></svg>", html
  end

  def test_unicode_emojify_for_known_in_svg_tags
    body = "<svg><text>:grinning:</text></svg>"
    html = html_from_fragment(body)
    expected = defined?(JRUBY_VERSION) ? "&#x1f600;" : "&#128512;"

    assert_equal "<svg><text>#{expected}</text></svg>", html
  end

  private

  def doc_from_fragment(str, opts = {:asset_root => 'https://foo.com'})
    AbbrEmojiFilter.new(str, opts).call
  end

  def html_from_fragment(str, opts = {:asset_root => 'https://foo.com'})
    AbbrEmojiFilter.new(str, opts).call.to_html(encoding:'US-ASCII').chomp
  end
end
