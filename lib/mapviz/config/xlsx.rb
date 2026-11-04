# frozen_string_literal: true

module Mapviz
  # Settings for accessing the correct worksheet (tab) in the mappings file
  module Xlsx
    module_function

    extend Dry::Configurable

    # @return [String] Name of worksheet (e.g. tab) where the mappings are
    #   recorded
    setting :worksheet,
      reader: true,
      default: "mappings"
  end
end
