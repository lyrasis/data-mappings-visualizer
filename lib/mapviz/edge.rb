# frozen_string_literal: true

module Mapviz
  # A diagram edge
  class Edge
    include Comparable

    attr_reader :source, :target

    def initialize(source:, target:)
      @source = source
      @target = target
    end

    def hash = [self.class, source, target].hash

    def <=>(other)
      hash <=> other.hash
    end

    def mermaid
      "  #{source.id}#{link}#{target.id}"
    end

    private

    def link
      val = Mapviz::Style.edge_for_target_node_type.dig(target.type)
      return val if val

      Mapviz::Style.default_edge
    end
  end
end
