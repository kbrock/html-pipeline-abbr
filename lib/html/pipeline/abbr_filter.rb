module HTML
  class Pipeline
    # uses defined abbreviations and add abbr tags around them

    class AbbrFilter < Filter
      include HTML::Pipeline::Abbr::Replace
      DEFINITION_PATTERN=%r{(?:^|\n)\*\[([^\]]+)\]: *(.+)$}.freeze
      RAW_ANCESTORS=%w(svg).freeze

      def call
        abbrs = extract_defs
        replace_abbrs(abbrs) unless abbrs.empty?
        doc
      end

      private

      def extract_defs
        abbrs = {}
        replace_nodes do |content, node|
          def_filter(content, abbrs) if content.include?("*[")
        end
        abbrs
      end

      # find abbrs in the code
      def replace_abbrs(abbrs)
        replace_nodes do |content, node|
          abbrs_filter(content, abbrs, !has_ancestor?(node, raw_ancestor_tags))
        end
      end

      def def_filter(content, abbrs)
        content.gsub(DEFINITION_PATTERN) do |match|
          abbrs[$1] = $2
          ""
        end
      end

      # Return html with abbreviations replaced
      #
      # @return [String] html with all abbreviations replaced
      def abbrs_filter(content, abbrs, abbr_tag = true)
        abbrs.inject(content) do |content, (abbr, full)|
          abbr_filter(content, abbr, full, abbr_tag)
        end
      end

      # Return html with all of an abbreviation replaced
      #
      # @return [String] html with abbreviation tags
      def abbr_filter(content, abbr, full, abbr_tag = true)
        target_html = abbr_tag ? abbr_tag(abbr, full) : full
        content.gsub(/\b#{abbr}\b/) { |_| target_html } || content
      end

      # Return html string to use as an abbr tag
      #
      # @return [String] abbr html
      def abbr_tag(abbr, full)
        %(<abbr title="#{full}">#{abbr}</abbr>)
      end

      # Return ancestor tags to still convert, but not add abbr
      #
      # @return [Array<String>] Ancestor tags.
      def raw_ancestor_tags
        if context[:raw_ancestor_tags]
          RAW_ANCESTORS | context[:raw_ancestor_tags]
        else
          RAW_ANCESTORS
        end
      end
    end
  end
end
