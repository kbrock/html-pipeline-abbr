module HTML
  class Pipeline
    # uses defined abbreviations and add abbr tags around them

    class AbbrFilter < Filter
      include HTML::Pipeline::Abbr::Replace
      DEFINITION_PATTERN=%r{(?:^|\n)\*\[([^\]]+)\]: *(.+)$}

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
          abbrs_filter(content, abbrs, !has_ancestor?(node, %(svg)))
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
          if abbr_tag
            abbr_filter(content, abbr, full)
          else
            replace_value(content, abbr, full)
          end
        end
      end

      def replace_value(content, abbr, full)
        content.gsub(/\b#{abbr}\b/) { |_| full } || content
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
    end
  end
end
