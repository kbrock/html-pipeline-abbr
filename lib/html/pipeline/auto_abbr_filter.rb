module HTML
  class Pipeline
    # Similar to abbreviate
    # but it starts with the long format and shortens it
    class AutoAbbrFilter < AbbrFilter
      # Return abreviation text (svg does not have abbr)
      #
      # @param [Boolean] abbr_tag true to include outer html tag (otherwise just abbr )
      # @return [String] html with abbreviation tags
      def abbr_filter(content, abbr, full, abbr_tag = true)
        target_html = abbr_tag ? abbr_tag(abbr, full) : abbr
        content.gsub(/\b#{full}\b/) { |_| target_html } || content
      end
    end
  end
end
