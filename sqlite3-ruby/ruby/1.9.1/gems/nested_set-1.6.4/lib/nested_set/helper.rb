# encoding: utf-8
module CollectiveIdea #:nodoc:
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      # This module provides some helpers for the model classes using acts_as_nested_set.
      # It is included by default in all views.
      #
      module Helper
        # Returns options for select.
        # You can exclude some items from the tree.
        # You can pass a block receiving an item and returning the string displayed in the select.
        #
        # == Params
        #  * +class_or_item+ - Class name or top level times
        #  * +mover+ - The item that is being move, used to exlude impossible moves
        #  * +&block+ - a block that will be used to display: { |item| ... item.name }
        #
        # == Usage
        #
        #   <%= f.select :parent_id, nested_set_options(Category, @category) {|i, level|
        #       "#{'–' * level} #{i.name}"
        #     }) %>
        #
        def nested_set_options(class_or_item, mover = nil)
          class_or_item = class_or_item.roots if class_or_item.is_a?(Class)
          items = Array(class_or_item)
          result = []
          items.each do |item|
            item.self_and_descendants.each_with_level do |i, level|
              if mover.nil? || mover.new_record? || mover.move_possible?(i)
                result.push([yield(i, level), i.id])
              end
            end
          end
          result
        end

        # Returns options for select.
        # You can sort node's child by any method
        # You can exclude some items from the tree.
        # You can pass a block receiving an item and returning the string displayed in the select.
        #
        # == Params
        #  * +class_or_item+ - Class name or top level times
        #  * +sort_proc+ sorting proc for node's child, ex. lambda{|x| x.name}
        #  * +mover+ - The item that is being move, used to exlude impossible moves
        #  * +level+ - start level, :default => 0
        #  * +&block+ - a block that will be used to display: { |itemi, level| "#{'–' * level} #{i.name}" }
        # == Usage
        #
        #   <%= f.select :parent_id, sorted_nested_set_options(Category, lambda(&:name)) {|i, level|
        #       "#{'–' * level} #{i.name}"
        #     }) %>
        #
        #   OR
        #
        #   sort_method = lambda{|x| x.name.mb_chars.downcase }
        #
        #   <%= f.select :parent_id, nested_set_options(Category, sort_method) {|i, level|
        #       "#{'–' * level} #{i.name}"
        #     }) %>
        #
        def sorted_nested_set_options(class_or_item, sort_proc, mover = nil, level = 0)
          hash = if class_or_item.is_a?(Class)
                   class_or_item
                 else
                   class_or_item.self_and_descendants
                 end.arrange
          build_node(hash, sort_proc, mover, level){|x, lvl| yield(x, lvl)}
        end

        def build_node(hash, sort_proc, mover = nil, level = nil)
          result = []
          hash.keys.sort_by(&sort_proc).each do |node|
            if mover.nil? || mover.new_record? || mover.move_possible?(node)
              result.push([yield(node, level.to_i), node.id])
              result.push(*build_node(hash[node], sort_proc, mover, level.to_i + 1){|x, lvl| yield(x, lvl)})
            end
          end if hash.present?
          result
        end

        # Recursively render arranged nodes hash
        #
        # == Params
        #  * +hash+ - Hash or arranged nodes, i.e. Category.arranged
        #  * +options+ - HTML options for root ul node.
        #    Given options with ex. :sort => lambda{|x| x.name}
        #    you allow node sorting by analogy with sorted_nested_set_options helper method
        #  * +&block+ - A block that will be used to display node
        #
        # == Usage
        #
        #   arranged_nodes = Category.arranged
        #
        #   <%= render_tree arranged_nodes do |node, child| %>
        #     <li><%= node.name %></li>
        #     <%= child %>
        #   <% end %>
        #
        def render_tree hash, options = {}, &block
          sort_proc = options.delete :sort
          content_tag :ul, options do
            hash.keys.sort_by(&sort_proc).each do |node|
              block.call node, render_tree(hash[node], :sort => sort_proc, &block)
            end
          end if hash.present?
        end

      end
    end
  end
end
