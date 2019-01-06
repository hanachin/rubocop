# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop enforces the use the method reference operator.
      #
      # @example
      #   # bad
      #   42.method(:to_s)
      #
      #   # good
      #   42.:to_s
      class MethodReferenceOperator < Cop
        # TODO: wait 2.7 support
        # extend TargetRubyVersion
        include RangeHelp

        MSG = 'Prefer `.:%<method>s` over `.method(%<original>s)`'.freeze

        # TODO: wait 2.7 support
        # minimum_target_ruby_version 2.7

        def_node_matcher :method_method?, '(send _ :method ({sym str} $_))'

        def on_send(node)
          method_method?(node) do |method|
            return if method.to_s.include?(' ')

            message = format(MSG, original: method.inspect, method: method)
            add_offense(node, message: message, location: offending_range(node))
          end
        end

        def autocorrect(node)
          range = offending_range(node)
          method_name = method_method?(node)
          lambda do |corrector|
            corrector.remove(range)
            corrector.insert_before(range, ".:#{method_name}")
          end
        end

        private

        def offending_range(node)
          start_pos = node.loc.dot.begin_pos
          end_pos = node.loc.expression.end_pos
          range_between(start_pos, end_pos)
        end
      end
    end
  end
end
