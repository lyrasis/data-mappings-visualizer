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

    # @param source [#match] value against which to map the original source
    #   field of each mapping
    # @param omitted [Boolean] if true, do not include omitted mappings
    # @param unmapped [Boolean] if true, do not include unmapped mappings
    # @return [Array<Mapviz::Mapping>]
    def for_source(source:, omitted: true, unmapped: true)
      filter(omitted: omitted, unmapped: unmapped).select do |mapping|
        Mapviz::Values.orig_source.call(mapping).match?(source)
      end
    end

    private

    def omitted_mappings = @omitted ||= all.select do |m|
      Mapviz::Logic.is_omitted.call(m)
    end

    def unmapped_mappings = @unmapped ||= all.select do |m|
      Mapviz::Logic.is_unmapped.call(m)
    end
  end
end
