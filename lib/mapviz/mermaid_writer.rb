# frozen_string_literal: true

module Mapviz
  # Handles writing mermaid file from given mappings
  class MermaidWriter
    def initialize(mappings:, path: Mapviz::Path.default_mmd_file)
      @mappings = mappings.map { |m| Mapviz::NodeAndEdgeMaker.new(m) }
      @path = path
    end

    def call
      File.open(path, "w") { |mmd| mmd << parts }

      puts "Wrote #{path}"
    end

    private

    attr_reader :mappings, :path

    def parts
      [
        frontmatter,
        elk_config,
        begin_graph,
        style_defs,
        "  %% node definitions",
        nodes,
        "  %% edge definitions",
        edges
      ].reject(&:blank?)
        .join("\n")
    end

    def frontmatter
      result = []
      result << "---"
      result << "config:"
      result << "  flowchart:"
      result << "    theme: #{Mapviz::Mermaid.theme}"
      result << "    look: #{Mapviz::Mermaid.look}"
      result << "    layout: #{Mapviz::Mermaid.layout}"
      result << "    curve: #{Mapviz::Mermaid.curve}"

      result.join("\n")
    end

    def style_defs = Mapviz::Style.node_type_to_style
      .values
      .reject(&:empty?)
      .map { |h| "  classDef #{h[:classname]} #{h[:def]}" }
      .join("\n")

    def elk_config
      return unless Mapviz::Mermaid.layout == "elk"

      [
        "  elk:",
        "    nodePlacementStrategy: "\
          "#{Mapviz::Mermaid.elk_node_placement_strategy}"
      ].join("\n")
    end

    def begin_graph
      [
        "---",
        "flowchart #{Mapviz::Mermaid.direction}"
      ].join("\n")
    end

    def nodes = mappings.map(&:nodes)
      .flatten
      .uniq
      .map(&:mermaid)
      .join("\n")

    def edges = mappings.map(&:edges)
      .flatten
      .uniq
      .map(&:mermaid)
      .join("\n")
  end
end
