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

  def test_abbr_spaces
    result = html_from_fragment("<p>Hyper text is great</p><p>*[HTML]: Hyper text</p>")
    assert_equal %(<p><abbr title="Hyper text">HTML</abbr> is great</p>), result
  end

  def test_abbr_other_abbr
    result = html_from_fragment("<p>Hypertext is great\n*[HTML]: Hypertext\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p><abbr title="Hypertext">HTML</abbr> is great</p>), result
  end

  def test_abbr_punct
    result = html_from_fragment(%(<p>"Hyper text!" is great</p><p>*[HTML]: Hyper text</p>))
    assert_equal %(<p>"<abbr title="Hyper text">HTML</abbr>!" is great</p>), result
  end

  # multiple

  def test_multiple_abbr
    html=%(<abbr title="Hypertext">HTML</abbr>)
    css=%(<abbr title="Stylesheets">CSS</abbr>)
    result = html_from_fragment("<p>Hypertext and Stylesheets are great\n*[HTML]: Hypertext\n*[CSS]: Stylesheets</p>")
    assert_equal %(<p>#{html} and #{css} are great</p>), result
  end

  def test_duplicate_abbr
    agree=%(<abbr title="agree">YES</abbr>)
    result = html_from_fragment("<p>agree agree\n*[YES]: agree</p><p>agree</p>")
    assert_equal %(<p>#{agree} #{agree}</p><p>#{agree}</p>), result
  end

  def test_similar_abbr
    agree=%(<abbr title="agree">AG</abbr>)
    disagree=%(<abbr title="disagree">NAG</abbr>)
    result = html_from_fragment("<p>agree disagree agree\n*[AG]: agree\n*[NAG]: disagree</p><p>agree</p><p>disagree</p>")
    assert_equal %(<p>#{agree} #{disagree} #{agree}</p><p>#{agree}</p><p>#{disagree}</p>), result
  end

  def test_similar_abbr_rev
    agree=%(<abbr title="agree">AG</abbr>)
    disagree=%(<abbr title="disagree">NAG</abbr>)
    result = html_from_fragment("<p>agree disagree agree\n*[NAG]: disagree\n*[AG]: agree</p><p>agree</p><p>disagree</p>")
    assert_equal %(<p>#{agree} #{disagree} #{agree}</p><p>#{agree}</p><p>#{disagree}</p>), result
  end

  private

  def abbr(abbr, title)
    %(<abbr title="#{title}">#{abbr}</abbr>)
  end
end
