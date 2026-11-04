# frozen_string_literal: true

module Mapviz
  # Settings that allow us to determine things about a given mappings row

  # @note Each of these methods should return a Lambda that takes a
  #   `mapping` param (a {Mapviz::Mapping} created from the mappings
  #   row), and returns `true` or "falsey". The `@return` values
  #   documented are for the Lambda returned by the method, not the
  #   setting method itself.
  module Logic
    module_function

    extend Dry::Configurable

    # @return [true] if row represents a mapping that will be implemented
    #   in the migration
    # @return [nil, false] otherwise
    # @note This represents intent, not whether the mapping is already
    #   determined or implemented.
    setting :is_migrating,
      reader: true,
      default: ->(mapping) { Mapviz::Values.included.call(mapping) == "y" }

    # @return [true] if row represents a mapping that will not be
    #   implemented in the migration
    # @return [nil, false] otherwise
    setting :is_omitted,
      reader: true,
      default: ->(mapping) { Mapviz::Values.included.call(mapping) == "n" }

    # @return [true] if row represents a mapping for a source field that has not
    #   yet been recorded: inclusion/omission isn't recorded, or if recorded,
    #   no final or intermediate target for the mapping is recorded
    # @return [nil, false] otherwise
    setting :is_unmapped,
      reader: true,
      default: ->(mapping) do
        val = Mapviz::Values.included.call(mapping)
        return false if val == "n"
        return true if val.blank? || val == "q"

        target = Mapviz::Values.target_field_machine.call(mapping)
        true if target.blank? || target == "."
      end

    # @return [true] if row represents a mapping from an original field in
    #   the client data
    # @return [nil, false] otherwise
    setting :is_orig,
      reader: true,
      default: ->(mapping) do
        Mapviz::Values.source_type.call(mapping) == "0 - Mimsy export"
      end

    # @return [true] if row represents a mapping from a derived,
    #   intermediate field
    # @return [nil, false] otherwise
    setting :is_intermediate_source,
      reader: true,
      default: ->(mapping) do
        Mapviz::Values.source_type.call(mapping)&.start_with?("1 - migration")
      end

    # @return [true] if row represents a mapping to a derived,
    #   intermediate field
    # @return [nil, false] otherwise
    setting :is_intermediate_target,
      reader: true,
      default: ->(mapping) do
        Mapviz::Values.target_record.call(mapping) ==
          "intermediate derived field"
      end

    # @return [true] if row represents a mapping to a final field in the
    #   target system
    # @return [nil, false] otherwise
    setting :is_final_target,
      reader: true,
      default: ->(mapping) do
        !Mapviz::Values.target_field_user.call(mapping).blank?
      end

    # @return [true] if row represents a mapping whose status indicates the
    #   mapped data is loaded into the target system
    # @return [nil, false] otherwise
    # @note Typically used to narrow down a set of final target mappings
    #   that can be reviewed by the client in the target system
    setting :is_loaded,
      reader: true,
      default: ->(mapping) do
        Mapviz::Logic.is_final_target.call(mapping) &&
          Mapviz::Values.status.call(mapping) == "loaded"
      end
  end
end
