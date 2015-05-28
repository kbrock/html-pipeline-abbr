module HTML
  class Pipeline
    module Abbr
      # depends upon ignored_ancestor_tags being present
      module Replace
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
      end
    end
  end
end
