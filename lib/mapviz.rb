# frozen_string_literal: true

require "active_support/core_ext/object"
require "dry-configurable"
require "pry"

module Mapviz
  module_function

  def loader
    @loader ||= setup_loader
  end

  # @return [Array<Hash>]
  def worksheet = @worksheet ||= Mapviz::Worksheet.new

  # @param exclude_omitted [Boolean] if true, do not include sources from
  #   omitted mappings
  # @param exclude_unmapped [Boolean] if true, do not include sources from
  #   unmapped mappings
  # @return [Array<String>]
  def orig_sources(exclude_omitted: true, exclude_unmapped: true)
    Mapviz::Mappings.new
      .filter(omitted: exclude_omitted, unmapped: exclude_unmapped)
      .select { |m| Mapviz::Logic.is_orig.call(m) }
      .map { |m| Mapviz::Values.source.call(m) }
      .uniq
      .sort
  end

  # @return [Array<String>]
  def targets
    Mapviz::Mappings.new
      .filter
      .select { |m| Mapviz::Logic.is_final_target.call(m) }
      .map { |m| Mapviz::Values.target_id.call(m) }
      .uniq
      .sort
  end

  def setup_loader
    @loader = Zeitwerk::Loader.new
    @loader.collapse(File.join(__dir__, "mapviz", "config"))
    @loader.push_dir(File.dirname(__FILE__))
    @loader.setup
    @loader
  end
  private_class_method :setup_loader
end

Mapviz.loader

[Mapviz::Path.mermaid_dir, Mapviz::Path.pdf_dir].each do |dir|
  FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
end
