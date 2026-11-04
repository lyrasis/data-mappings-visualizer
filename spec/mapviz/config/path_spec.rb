# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Path" do
  describe ".project_dir" do
    it "returns expected path" do
      expected = File.join(Bundler.root, "spec",
        "support", "tmp")
      expect(Mapviz::Path.project_dir).to eq(expected)
    end
  end

  describe ".mappings_file" do
    it "returns expected path" do
      expected = File.join(Bundler.root, "spec",
        "support", "fixtures", "mappings.xlsx")
      expect(Mapviz::Path.mappings_file).to eq(expected)
    end
  end

  describe ".mermaid_dir" do
    it "returns expected path" do
      expected = File.join(Bundler.root, "spec",
        "support", "tmp", "mappings", "mermaid")
      expect(Mapviz::Path.mermaid_dir).to eq(expected)
    end
  end

  describe ".pdf_dir" do
    it "returns expected path" do
      expected = File.join(Bundler.root, "spec",
        "support", "tmp", "mappings", "graphs")
      expect(Mapviz::Path.pdf_dir).to eq(expected)
    end
  end
end
