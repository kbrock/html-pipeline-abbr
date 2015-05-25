module HTML
  class Pipeline
    # Similar to abbreviate
    # but it starts with the long format and shortens it
    class AutoAbbrFilter < AbbrFilter
      def abbr_filter(content, abbr, full)
        target_html = abbr_tag(abbr, full)
        content.gsub(/\b#{full}\b/) { |_| target_html } || content
      end
    end
  end
end
