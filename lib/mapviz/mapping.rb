# frozen_string_literal: true

module Mapviz
  # Mapping row converted to Object with a method created for each Hash key
  class Mapping
    attr_reader :row

    # @param row [Hash{Symbol => String}]
    def initialize(row)
      @row = row
    end

    def method_missing(symbol)
      row[symbol]
    rescue
      nil
    end

    def respond_to_missing?(name, include_private = false)
      row.key?(name)
    end
  end
end
