# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:tools)

# require_relative "helpers"
require "dry/configurable/test_interface"
require "mapviz"
require "pry"

Mapviz::Headers.enable_test_interface
Mapviz::Logic.enable_test_interface
Mapviz::Values.enable_test_interface

RSpec.configure do |config|
  # config.include Helpers

  config.before(:suite) do
    Mapviz::Path.config.project_dir = File.join(Bundler.root, "spec",
      "support", "tmp")
    Mapviz::Path.config.mappings_file = File.join(Bundler.root, "spec",
      "support", "fixtures", "mappings.xlsx")
    puts "Initial Mapviz::Path configuration set up"
  end

  # random but deterministic test order
  config.order = :random
  Kernel.srand config.seed

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end
