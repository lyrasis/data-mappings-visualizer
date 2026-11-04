# frozen_string_literal: true

module Mapviz
  # Settings related to the location of required input files as well as output
  module Path
    module_function

    extend Dry::Configurable

    # @return [String] path to your project data base folder
    # @note Optional if you want to manually set the full paths of the other
    #   settings in this file. If not using, set default to `nil`.
    setting :project_dir,
      reader: true,
      default: File.expand_path(
        File.join("~", "data", "scottishrite", "mig")
      )

    # @return [String] path to .xlsx file containing your mappings
    setting :mappings_file,
      reader: true,
      default: nil,
      constructor: ->(default) do
        return default if default

        File.join(project_dir, "Scottish Rite Mappings.xlsx")
      end

    # @return [String] path to directory where output Mermaid .mmd files should
    #   be written
    setting :mermaid_dir,
      reader: true,
      default: nil,
      constructor: ->(default) do
        return default if default

        File.join(project_dir, "mappings", "mermaid")
      end

    # @return [String] path to directory where output PDF files should be
    #   written
    setting :pdf_dir,
      reader: true,
      default: nil,
      constructor: ->(default) do
        return default if default

        File.join(project_dir, "mappings", "graphs")
      end
  end
end
