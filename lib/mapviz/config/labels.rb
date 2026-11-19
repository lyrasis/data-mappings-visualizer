# frozen_string_literal: true

module Mapviz
  # Settings that control the labels added to graph nodes and edges
  # @note Each of these methods should return a Lambda that takes a
  #   `mapping` param (a {Mapviz::Mapping} created from the mappings
  #   row), and returns a String
  module Labels
    module_function

    extend Dry::Configurable

    setting :omitted_node,
      reader: true,
      default: ->(_mapping) { "Omitted from migration" }

    setting :unmapped_node,
      reader: true,
      default: ->(_mapping) { "Not yet mapped" }

    # @return [String] used as label of source nodes
    setting :source_node,
      reader: true,
      default: ->(mapping) do
        base = Mapviz::Values.source.call(mapping)
        dbtab = "DB TAB: #{mapping.DB_TAB}"
        dbsrc = "ON SCREEN IN DB: #{mapping.ON_SCREEN_IN_DB}"
        "#{base}\n#{dbtab} / #{dbsrc}"
      end

    setting :intermediate_target_node,
      reader: true,
      default: ->(mapping) do
        Mapviz::Values.target_field_machine.call(mapping)
      end

    setting :final_target_node,
      reader: true,
      default: ->(mapping) do
        path = [
          Mapviz::Values.target_field_user.call(mapping),
          Mapviz::Values.target_field_machine.call(mapping)
        ].reject(&:blank?).join(" > ")
        [
          Mapviz::Values.target_record.call(mapping)&.upcase,
          path
        ].compact.join("\n")
      end
  end
end
