# frozen_string_literal: true

module Mapviz
  # Settings related to writing of Mermaid .mmd files
  module Mermaid
    module_function

    extend Dry::Configurable

    # @return [String] layout direction of the flowchart; See
    #   https://mermaid.js.org/syntax/flowchart.html#direction for
    #   valid values
    setting :direction,
      reader: true,
      default: "LR"

    # @return [String] See https://mermaid.js.org/config/theming.html for
    #    valid values
    setting :theme,
      reader: true,
      default: "forest"

    # @return [String] See
    #   https://mermaid.js.org/intro/syntax-reference.html#layout-and-look
    #   for valid values
    setting :look,
      reader: true,
      default: "classic"

    # @return [String] See
    #   https://mermaid.js.org/intro/syntax-reference.html#layout-and-look
    #   for valid values
    setting :layout,
      reader: true,
      default: "elk"

    # @return [String] See
    #   https://eclipse.dev/elk/reference/options/org-eclipse-elk-layered-nodePlacement-strategy.html
    #   for valid values
    setting :elk_node_placement_strategy,
      reader: true,
      default: "LINEAR_SEGMENTS"

    # @return [String] See
    #   https://mermaid.js.org/syntax/flowchart.html#styling-line-curves
    #   for valid values
    setting :curve,
      reader: true,
      default: "bundle"
  end
end
