# frozen_string_literal: true

require "delegate"

module Mapviz
  # Aggregate class of Mapviz::Mapping objects derived from worksheet rows
  class Mappings < SimpleDelegator
    attr_reader :all

    def initialize
      @all = Mapviz.worksheet.rows
        .map { |row| Mapviz::Mapping.new(row) }
      __setobj__(@all)
    end

    # @param omitted [Boolean] if true, do not include omitted mappings
    # @param unmapped [Boolean] if true, do not include unmapped mappings
    # @return [Array<Mapviz::Mapping>]
    def filter(omitted: true, unmapped: true)
      drop = []
      drop << omitted_mappings if omitted
      drop << unmapped_mappings if unmapped
      all - drop.flatten.uniq
    end

    # @param source [#match] value against which to match the original source
    #   field of each mapping
    # @param exclude_omitted [Boolean] if true, do not include omitted mappings
    # @param exclude_unmapped [Boolean] if true, do not include unmapped
    #   mappings
    # @return [Array<Mapviz::Mapping>]
    def for_source(source:, exclude_omitted: true, exclude_unmapped: true)
      filter(
        omitted: exclude_omitted,
        unmapped: exclude_unmapped
      ).select do |mapping|
        val = Mapviz::Values.orig_source.call(mapping)
        next if val.blank?

        val.split("|").any? { |v| v.match?(source) }
      end
    end

    # @param target [#match] value against which to match the target_id field
    #   value of each mapping
    # @param exclude_omitted [Boolean] if true, do not include omitted mappings
    # @param exclude_unmapped [Boolean] if true, do not include unmapped
    #   mappings
    # @return [Array<Mapviz::Mapping>]
    def for_target(target:, exclude_omitted: true, exclude_unmapped: true)
      filtered = filter(
        omitted: exclude_omitted,
        unmapped: exclude_unmapped
      )
      base = filtered.select do |mapping|
        Mapviz::Values.target_id.call(mapping).match?(target)
      end

      compile_ancestors(base, filtered)
    end

    private

    def omitted_mappings = @omitted ||= all.select do |m|
      Mapviz::Logic.is_omitted.call(m)
    end

    def unmapped_mappings = @unmapped ||= all.select do |m|
      Mapviz::Logic.is_unmapped.call(m)
    end

    def compile_ancestors(base, filtered)
      base.map { |mapping| ancestors(mapping, filtered) }
        .flatten
        .uniq
    end

    def ancestors(mapping, filtered, result = nil)
      return [mapping] if Mapviz::Logic.is_orig.call(mapping)

      result ||= [[mapping]]

      until result.last.blank? || no_more_ancestors?(result.last)
        prev = result.last.map { |m| get_previous_gen(m, filtered) }
          .flatten
        result << prev.flatten.compact
      end

      result.flatten.compact
    end

    def no_more_ancestors?(arr) = need_prev(arr).empty?

    def need_prev(arr) = arr.reject { |m| Mapviz::Logic.is_orig.call(m) }

    def get_previous_gen(mapping, filtered)
      src = Mapviz::Values.source.call(mapping)
      filtered.select { |x| Mapviz::Values.target_field_machine.call(x) == src }
    end
  end
end
