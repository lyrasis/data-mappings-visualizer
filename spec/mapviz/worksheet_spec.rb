# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Worksheet" do
  subject(:worksheet) { Mapviz::Worksheet.new }

  describe ".headers" do
    it "returns Array of Symbols" do
      result = worksheet.headers
      expect(result).to be_a(Array)
      expect(result.first).to be_a(Symbol)
    end
  end

  describe ".rows" do
    it "returns Array of Hashes" do
      result = worksheet.rows
      expect(result).to be_a(Array)
      expect(result.length).to eq(239)
      expect(result.first).to be_a(Hash)
    end
  end
end
