# frozen_string_literal: true

module Mapviz
  # Settings related to style of edges/nodes in rendered diagram
  module Style
    module_function

    extend Dry::Configurable

    # @return [String] between source and target node in Mermaid syntax; See
    #   https://mermaid.js.org/syntax/flowchart.html#links-between-nodes
    #   for options
    setting :default_edge,
      reader: true,
      default: "==>"

    # @return [Hash{Symbol => String}] edge string to use for links of the
    #   given target type; If there's no key for the target type,
    #   {default_edge} is used
    setting :edge_for_target_node_type,
      reader: true,
      default: {
        constraint: "-->",
        detail: "-->"
      }

    setting :node_type_prefix,
      reader: true,
      default: {
        constraint: "❓",
        detail: "✎",
        final_loaded: "✔",
        omitted: "🚫"
      }

    # @return [Hash{Symbol => String}] Symbol is Node type value; String is
    #   a supported Mermaid node shape; See
    #   https://mermaid.js.org/syntax/flowchart.html#node-shapes and
    #   https://mermaid.js.org/syntax/flowchart.html#expanded-node-shapes-in-mermaid-flowcharts-v11-3-0
    setting :node_type_to_node_shape,
      reader: true,
      default: {
        constraint: "subproc",
        detail: "braces",
        final: "stadium",
        final_loaded: "stadium",
        intermediate: "bow-rect",
        omitted: "odd",
        orig: "lean-r",
        unknown: "lin-doc",
        unmapped: "odd"
      }

    # @return [Hash{Symbol => String}] Symbol is Node type value; String is
    #   a supported Mermaid node shape; See
    #   https://mermaid.js.org/syntax/flowchart.html#node-shapes and
    #   https://mermaid.js.org/syntax/flowchart.html#expanded-node-shapes-in-mermaid-flowcharts-v11-3-0
    # @note default is not a node type, but any nodes with no associated class
    #   will use this style
    setting :node_type_to_style,
      reader: true,
      default: {
        constraint: {
          classname: "constraint",
          def: "fill:#fff,color:#7d7d7d,stroke:#7d7d7d"
        },
        default: {
          classname: "default",
          def: "fill:#7d7d7d,color:#fff"
        },
        detail: {
          classname: "detail",
          def: "color:#7d7d7d,stroke:#7d7d7d"
        },
        final: {
          classname: "final",
          def: "fill:#2e2e2e,color:#ededed"
        },
        final_loaded: {
          classname: "loaded",
          def: "fill:#2e2e2e,color:#ededed"
        },
        intermediate: {},
        omitted: {},
        orig: {
          classname: "orig",
          def: "fill:#7d7d7d,color:#fff,stroke:#2e2e2e"
        },
        unknown: {},
        unmapped: {}
      }
  end
end
