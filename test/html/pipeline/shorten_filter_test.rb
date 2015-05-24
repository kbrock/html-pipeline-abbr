require 'minitest_helper'

class Html::Pipeline::ShortenFilterTest < Minitest::Test
  ShortenFilter = HTML::Pipeline::ShortenFilter

  def html_from_fragment(str)
    ShortenFilter.new(str, {}).call.to_html.chomp
  end

  def test_no_change
    result = html_from_fragment("<p>Hypertext is great</p>")
    assert_equal %(<p>Hypertext is great</p>), result
  end

  def test_no_change_other_abbr
    result = html_from_fragment("<p>Hypertext is great\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p>Hypertext is great</p>), result
  end

  def test_abbr
    result = html_from_fragment("<p>Hypertext is great\n*[HTML]: Hypertext</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> is great</p>), result
  end

  def test_abbr_multi_nodes
    result = html_from_fragment("<p>Hypertext is great</p><p>*[HTML]: Hypertext</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> is great</p>), result
  end

  def test_abbr_other_abbr
    result = html_from_fragment("<p>Hypertext is great\n*[HTML]: Hypertext\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> is great</p>), result
  end

  def test_multi_abbr_other_abbr
    result = html_from_fragment("<p>Hypertext and Stylesheets are great\n*[HTML]: Hypertext\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> and <abbr title="Stylesheets">CSS</abbr> are great</p>), result
  end
end
