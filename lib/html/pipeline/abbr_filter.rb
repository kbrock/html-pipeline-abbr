module HTML
  class Pipeline
    # uses defined abbreviations and add abbr tags around them

    class AbbrFilter < Filter
      DEFAULT_IGNORED_ANCESTOR_TAGS = %w(pre code tt).freeze
      DEFINITION_PATTERN=%r{(?:^|\n)\*\[([^\]]+)\]: *(.+)$}

      def call
        abbrs = extract_defs
        replace_abbrs(abbrs) unless abbrs.empty?
        doc
      end

      private

      def extract_defs
        abbrs ||= {}
        replace_nodes do |content|           
          def_filter(content, abbrs) if content.include?("*[")
        end
        abbrs
      end

      # find abbrs in the code
      def replace_abbrs(abbrs)
        replace_nodes do |content|
          abbrs_filter(content, abbrs)
        end
      end

      # for reach of the text nodes that we can modify
      def replace_nodes
        doc.xpath(".//text()").each do |node|
          next if has_ancestor?(node, ignored_ancestor_tags)

          content = node.to_html
          html = yield content

          next if html == content || html.nil?
          if html.length == 0
            node.parent.remove
          else
            node.replace(html)
          end
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
      def abbrs_filter(content, abbrs)
        abbrs.each do |abbr, full|
          content = abbr_filter(content, abbr, full)
        end
        content
      end

      # Return html with all of an abbreviation replaced
      #
      # @return [String] html with abbreviation tags
      def abbr_filter(content, abbr, full)
        target_html = abbr_tag(abbr, full)
        content.gsub(/\b#{abbr}\b/) { |_| target_html } || content
      end

      # Return html string to use as an abbr tag
      #
      # @return [String] abbr html
      def abbr_tag(abbr, full)
        %(<abbr title="#{full}">#{abbr}</abbr>)
      end

      # Return ancestor tags to stop processing
      #
      # @return [Array<String>] Ancestor tags.
      def ignored_ancestor_tags
        if context[:ignored_ancestor_tags]
          DEFAULT_IGNORED_ANCESTOR_TAGS | context[:ignored_ancestor_tags]
        else
          DEFAULT_IGNORED_ANCESTOR_TAGS
        end
      end
    end
  end
end
