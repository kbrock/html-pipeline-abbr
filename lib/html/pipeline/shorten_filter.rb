module HTML
  class Pipeline
    # Similar to abbreviate
    # but it starts with the long format and shortens it
    class ShortenFilter < AbbrFilter

      # Return html with abbreviations replaced
      #
      # @return [String] html with all abbreviations replaced
      def abbrs_filter(content, abbrs)
        abbrs.each do |abbr, full|
          content = abbr_filter(content, abbr, full) if content.include?(full)
        end
        content
      end

      def abbr_filter(content, abbr, full)
        target_html = abbr_tag(abbr, full)
        content.gsub(full) { |_| target_html }
      end
    end
  end
end
