# frozen_string_literal: true

require "active_support/core_ext/object"
require "dry-configurable"

module Mapviz
  module_function

  def loader
    @loader ||= setup_loader
  end

  # @return [Array<Hash>]
  def worksheet = @worksheet ||= Mapviz::Worksheet.new

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
