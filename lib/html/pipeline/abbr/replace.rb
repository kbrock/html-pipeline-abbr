module HTML
  class Pipeline
    module Abbr
      # depends upon ignored_ancestor_tags being present
      module Replace
        DEFAULT_IGNORED_ANCESTOR_TAGS = %w(pre code tt).freeze

        # for reach of the text nodes that we can modify
        # takes a block
        def replace_nodes
          doc.xpath(".//text()").each do |node|
            next if has_ancestor?(node, ignored_ancestor_tags)

            content = node.to_html
            html = yield content, node

            next if html == content || html.nil?
            if html.length == 0
              node.parent.remove
            else
              node.replace(html)
            end
          end
        end

        # Return ancestor tags to stop the emojification.
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
end
