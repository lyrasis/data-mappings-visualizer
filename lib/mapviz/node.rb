# frozen_string_literal: true

module Mapviz
  # A diagram node
  class Node
    include Comparable

    attr_reader :id, :label, :type

    def initialize(id:, label:, type:)
      @id = id
      @label = label
      @type = type
    end

    def hash = [self.class, id, label, type].hash

    def <=>(other)
      hash <=> other.hash
    end

    def mermaid
      parts = []
      parts << id
      parts << ":::#{styleclass}" if styleclass
      parts << "@{ shape: #{shape}, label: \"#{escaped_label}\" }"
      parts.join
    end

    private

    def shape = Mapviz::Style.node_type_to_node_shape[type]

    # @return [String, nil] name of CSS-like Mermaid style. See
    #   {Mapviz::Style.node_type_to_style}
    def styleclass = Mapviz::Style.node_type_to_style.dig(type, :classname)

    def escaped_label
      [
        Mapviz::Style.node_type_prefix.dig(type),
        label.gsub('"', "#quot;")
      ].compact.join(" ")
    end
  end
end
