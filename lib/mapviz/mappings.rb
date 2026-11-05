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
  end
end
