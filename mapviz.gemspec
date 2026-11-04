# frozen_string_literal: true

require_relative "lib/mapviz/version"

Gem::Specification.new do |spec|
  spec.name = "mapviz"
  spec.version = Mapviz::VERSION
  spec.authors = ["Kristina Spurgin"]
  spec.email = ["kristina.spurgin@lyrasis.org"]

  spec.summary = "Generate flowchart from mappings spreadsheet"
  spec.homepage = "https://github.com/lyrasis/data-mappings-visualizer"
  spec.license = "MIT"

  spec.required_ruby_version = ">=4.0.5"
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  #   'allowed_push_host' to allow pushing to a single host or delete this
  #   section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against "\
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  #   into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "dry-configurable"
  spec.add_dependency "roo"
  spec.add_dependency "zeitwerk"
end
