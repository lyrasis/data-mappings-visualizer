# frozen_string_literal: true

module Mapviz
  # Settings that identify the headers (column names) for each type of
  #  needed information.
  # @note Mappings worksheet headers are converted to Symbols when read in by
  #   this app. Any non-alphanumeric characters in headers are converted to
  #   underscores. Case of headers is retained.
  module Headers
    module_function

    extend Dry::Configurable

    # @return [Symbol] Column containing source field names, e.g. the fields we
    #   are mapping FROM in the transformation represented by each individual
    #   mapping row; source fields may be original client data source fields or
    #   intermediate fields created by other mappings
    setting :source,
      reader: true,
      default: :sourceField,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing type of source field; generally this
    #   will indicate whether {source} is original or derived
    setting :source_type,
      reader: true,
      default: :source,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing indication of whether or not {source}
    #   is included in the migration project
    setting :included,
      reader: true,
      default: :migrating,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing indication why source field is not
    #   included in the migration
    setting :omission_reason,
      reader: true,
      default: :omissionReason,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing the ORIGINAL source field
    #   value of each mapping is recorded, enabling us to filter to
    #   just the mappings that show where/how a given original field
    #   was mapped
    # @note If the data value a mapping row applies to is derived from more than
    #   one original source field, separate the original source field names with
    #  "|" (pipe character, typed as shift-\)
    setting :orig_source,
      reader: true,
      default: :origsourcefield,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing (hopefully brief) description of logic,
    #   conditions, or constraints on which set of {source} values the
    #   transformation represented by the row will apply to
    setting :constraint,
      reader: true,
      default: :conditions,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] column heading for field containing details of the
    #   mapping
    # @note This column is typically where you would record things like:
    #   constant values provided, prefixes/suffixes applied, summaries of
    #   extraction/transformation processes
    setting :detail,
      reader: true,
      default: :mappingNote,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing target record type, e.g. the record
    #   type the data transformed by the mapping will map to in the target
    #   system.
    # @note If the row represents a mapping to an intermediate field, the value
    #   in this column should indicate that "intermediateness" instead of an
    #   actual target record type
    setting :target_record,
      reader: true,
      default: :targetRecord,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing target field names, e.g. the fields we
    #   are mapping TO in the transformation represented by each individual
    #   mapping row; target fields can be intermediate fields created in the
    #   migration, or a final field in the target system
    # @note This app assumes the underlying machine name of the field
    #   is recorded in {target_field_machine}, and, for
    #   non-intermediate mappings, there is another column, recorded
    #   as {target_field_user}, in which the user-facing label of the
    #   final target field is recorded. If your mappings style does
    #   not follow this assumption, set both {target_field_machine} and
    #   {target_field_user} to the column where you record the target field.
    setting :target_field_machine,
      reader: true,
      default: :targetField,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] Column containing user-friendly version of
    #   non-intermediate target fields
    # @note This app assumes the underlying machine name of the field
    #   is recorded in {target_field_machine}, and, for
    #   non-intermediate mappings, there is another column, recorded
    #   as {target_field_user}, in which the user-facing label of the
    #   final target field is recorded. If your mappings style does
    #   not follow this assumption, set both {target_field_machine} and
    #   {target_field_user} to the column where you record the target field.
    setting :target_field_user,
      reader: true,
      default: :UILabel,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] column heading for field containing combined record type/
    #   field, used to uniquely identify a specific target field
    # @note If you record machine names of record types/fields, and have a
    #   lookup to pull in user-friendly field names, this is likely the
    #   concatenated field you use to do that lookup
    setting :target_id,
      reader: true,
      default: :target_id,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    # @return [Symbol] column heading for field containing status of the
    #   mapping; typically these are values such as `implemented`,
    #   `loaded`, `approved`
    setting :status,
      reader: true,
      default: :status,
      constructor: ->(default) { Mapviz::Headers.format_header(default) }

    def format_header(val)
      return val if val.is_a?(Symbol)

      val.gsub(/\W/, "_").to_sym
    end
  end
end
