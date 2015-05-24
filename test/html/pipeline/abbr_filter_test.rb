require 'minitest_helper'

class Html::Pipeline::AbbrFilterTest < Minitest::Test
  AbbrFilter = HTML::Pipeline::AbbrFilter

  def html_from_fragment(str)
    AbbrFilter.new(str, {}).call.to_html.chomp
  end

  def test_no_change
    result = html_from_fragment("<p>HTML is great</p>")
    assert_equal %(<p>HTML is great</p>), result
  end

  def test_no_change_other_abbr
    result = html_from_fragment("<p>HTML is great\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p>HTML is great</p>), result
  end

  def test_abbr
    result = html_from_fragment("<p>HTML is great\n*[HTML]: Hypertext</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> is great</p>), result
  end

  def test_abbr_multi_nodes
    result = html_from_fragment("<p>HTML is great</p><p>*[HTML]: Hypertext</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> is great</p>), result
  end

  def test_abbr_other_abbr
    result = html_from_fragment("<p>HTML is great\n*[HTML]: Hypertext\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> is great</p>), result
  end

  def test_multi_abbr_other_abbr
    result = html_from_fragment("<p>HTML and CSS are great\n*[HTML]: Hypertext\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> and <abbr title="Stylesheets">CSS</abbr> are great</p>), result
  end
end
