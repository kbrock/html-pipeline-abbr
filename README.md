# Html::Pipeline::Abbr

This adds Abbreviation support to your html-pipeline.

Some implementations of Markdown support `<abbr>`, but it is not standard yet.
It does look like [CommonMark] may include it. In the mean time, hope this
helps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'html-pipeline-abbr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-pipeline-abbr

## Usage

```ruby
pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::AbbrFilter,
]
result = pipeline.call <<-CODE
Lets generate some *great* HTML.

*[HTML]: Hypertext
CODE
puts result[:output].to_s
```
Prints:

```
<p>Lets generate some <strong>great</strong> <abbr title="Hypertxt">HTML</abbr>.</p>
```

On the flip side, there is also the `AutoAbbrFilter` which will find words that can be abbreviated and shorten them.

```ruby
pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::AutoAbbrFilter,
]
result = pipeline.call <<-CODE
Lets generate some *great* Hypertext.

*[HTML]: Hypertext
CODE
puts result[:output].to_s
```

It produces the same output:

```
<p>Lets generate some <strong>great</strong> <abbr title="Hypertxt">HTML</abbr>.</p>
```

## Development

## Thanks

Appreciated the sample tests and code from:

- https://github.com/lifted-studios/html-pipeline-cite
- https://github.com/JuanitoFatas/html-pipeline-rouge_filter

## Contributing

1. Fork it ( https://github.com/kbrock/html-pipeline-abbr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
