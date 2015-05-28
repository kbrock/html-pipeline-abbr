require 'html/pipeline/emoji_filter'

module HTML
  class Pipeline
    # This class is very similar to EmojiFilter.
    # It does not output any width/height attributes
    # so that css can take effect
    class AbbrEmojiFilter < EmojiFilter
      def emoji_image_filter(text)
        return text unless text.include?(':')

        text.gsub(emoji_pattern) do
          name = Regexp.last_match[1]
          result = "<img class='emoji' alt='#{name}' src='#{emoji_url(name)}' />"
        end
      end
    end
  end
end
