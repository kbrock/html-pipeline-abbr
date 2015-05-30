require 'html/pipeline/emoji_filter'

module HTML
  class Pipeline
    # This class is very similar to EmojiFilter.
    # It does not output any width/height attributes
    # so that css can take effect
    class AbbrEmojiFilter < EmojiFilter
      include HTML::Pipeline::Abbr::Replace

      DEFAULT_NON_HTML_TAGS = %w(svg).freeze

      def call
        replace_nodes do |content, node|
          non_html = has_ancestor?(node, non_html_tags)
          emoji_filter(content, non_html)
        end
        doc
      end

      def emoji_filter(text, non_html)
        return text unless text.include?(':')

        text.gsub(emoji_pattern) do
          name = Regexp.last_match[1]
          emoji = Emoji.find_by_alias(name)
          if non_html
            emoji.custom? ? name : emoji_unicode_text(emoji)
          elsif prefer_unicode
            emoji.custom? ? emoji_img_tag(name) : emoji_unicode_tag(emoji)
          else
            emoji_img_tag(name)
          end
        end
      end

      def emoji_img_tag(name)
        "<img class='emoji' alt='#{name}' src='#{emoji_url(name)}' />"
      end

      def emoji_unicode_tag(emoji)
        "<span class='emoji'>#{emoji_unicode_text(emoji)}"
      end

      def emoji_unicode_text(emoji)
        "&#x#{emoji.hex_inspect.sub(/-.*/, '')};"
      end

      # Return true if unicode is preferred in html
      #
      # @return [Array<String>|true] Ancestor tags.
      def prefer_unicode
        context[:prefer_unicode]
      end

      # Return ancestor tags that don't allow html
      # Return true if forcing unicode always
      #
      # @return [Array<String>|true] Ancestor tags.
      def non_html_tags
        if context[:non_html_tags]
          DEFAULT_NON_HTML_TAGS | context[:non_html_tags]
        else
          DEFAULT_NON_HTML_TAGS
        end
      end
    end
  end
end
