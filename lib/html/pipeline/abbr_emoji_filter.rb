require 'html/pipeline/emoji_filter'

module HTML
  class Pipeline
    # This class is very similar to EmojiFilter.
    # It does not output any width/height attributes
    # so that css can take effect
    class AbbrEmojiFilter < EmojiFilter
      include HTML::Pipeline::Abbr::Replace

      DEFAULT_UNICODE_ANCESTOR_TAGS = %w(svg).freeze

      def call
        replace_nodes do |content, node|
          if unicode_ancestor_tags == true || has_ancestor?(node, unicode_ancestor_tags)
            emoji_unicode_filter(content)
          else
            emoji_image_filter(content)
          end
        end
        doc
      end

      def emoji_image_filter(text)
        return text unless text.include?(':')

        text.gsub(emoji_pattern) do
          emoji_tag(Regexp.last_match[1])
        end
      end

      def emoji_unicode_filter(text)
        return text unless text.include?(':')

        text.gsub(emoji_pattern) do
          emoji_unicode_tag(Regexp.last_match[1])
        end
      end

      def emoji_tag(name)
        "<img class='emoji' alt='#{name}' src='#{emoji_url(name)}' />"
      end

      def emoji_unicode_tag(name)
        emoji = Emoji.find_by_alias(name)
        emoji.custom? ? name : "&#x#{emoji.hex_inspect.sub(/-.*/, '')};"
      end


      def prefer_unicode
        context[:prefer_unicode]
      end

      # Return ancestor tags to return unicode characters instead.
      #
      # @return [Array<String>|true] Ancestor tags.
      def unicode_ancestor_tags
        if context[:unicode_ancestor_tags] == true
          true
        elsif context[:unicode_ancestor_tags]
          DEFAULT_UNICODE_ANCESTOR_TAGS | context[:ignored_ancestor_tags]
        else
          DEFAULT_UNICODE_ANCESTOR_TAGS
        end
      end
    end
  end
end
