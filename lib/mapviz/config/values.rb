# frozen_string_literal: true

module Mapviz
  # Settings that extract specific values from mappings worksheet
  # @note Each of these methods should return a Lambda that takes a
  #   `mapping` param (a {Mapviz::Mapping} derived from a mappings
  #   worksheet row), and returns `nil` or a `String`
  # @note These are repetitive, manually entered methods to afford custom
  #   logic/formatting in how values get extracted. This is in order to
  #   support different practices in building mappings spreadsheets
  module Values
    module_function

    extend Dry::Configurable

    setting :source,
      reader: true,
      default: ->(mapping) { mapping.send(Mapviz::Headers.source) }

    setting :source_type,
      reader: true,
      default: ->(_mapping) { "orig" }

    setting :included,
      reader: true,
      default: ->(_mapping) { "y" }

    setting :omission_reason,
      reader: true,
      default: ->(_mapping) { "" }

    setting :orig_source,
      reader: true,
      default: ->(mapping) { mapping.send(Mapviz::Headers.source) }

    setting :constraint,
      reader: true,
      default: ->(mapping) { "" }

    setting :detail,
      reader: true,
      default: ->(mapping) do
        [
          mapping.send(Mapviz::Headers.constraint),
          mapping.send(Mapviz::Headers.detail)
        ].reject do |val|
          val.blank? || val == "." || val == "na"
        end.join("\n")
      end

    setting :target_record,
      reader: true,
      default: ->(mapping) { mapping.send(Mapviz::Headers.target_record) }

    setting :target_field_machine,
      reader: true,
      default: ->(mapping) do
        val = mapping.send(Mapviz::Headers.target_field_machine)
        return if val.blank? || val == "."

        val
      end

    setting :target_field_user,
      reader: true,
      default: ->(mapping) do
        val = mapping.send(Mapviz::Headers.target_field_user)
        return if val.blank? || val == "."

        val
      end

    setting :target_id,
      reader: true,
      default: ->(mapping) { mapping.send(Mapviz::Headers.target_id) }

    setting :status,
      reader: true,
      default: ->(mapping) do
        val = mapping.send(Mapviz::Headers.status)
        return if val.blank? || val == "."

        val
      end
  end
end
