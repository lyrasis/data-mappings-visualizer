# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Mappings" do
  subject(:mappings) { Mapviz::Mappings.new }

  it "delegates Array of Mapviz::Mapping Objects" do
    expect(mappings.length).to eq(239)
    expect(mappings.first).to be_a(Mapviz::Mapping)
  end

  describe "#filter" do
    let(:result) { mappings.filter(**args) }

    context "when rejecting omitted" do
      let(:args) { {omitted: true, unmapped: false} }

      it "returns expected mappings" do
        expect(result.length).to eq(203)
      end
    end

    context "when rejecting unmapped" do
      let(:args) { {omitted: false, unmapped: true} }

      it "returns expected mappings" do
        expect(result.length).to eq(229)
      end
    end

    context "when rejecting omitted and unmapped" do
      let(:args) { {omitted: true, unmapped: true} }

      it "returns expected mappings" do
        expect(result.length).to eq(193)
      end
    end
  end

  describe "for_source" do
    let(:result) { mappings.for_source(**args) }

    context "with CONDITION ASSESSMENT, no omitted or unmapped" do
      let(:args) do
        {source: "CONDITION ASSESSMENT", omitted: true, unmapped: true}
      end

      it "returns expected mappings" do
        expect(result.length).to eq(7)
      end
    end

    context "with /^create/i, no omitted or unmapped" do
      let(:args) do
        {source: /^create/i, omitted: true, unmapped: true}
      end

      it "returns expected mappings" do
        expect(result.length).to eq(11)
      end
    end
  end
end
