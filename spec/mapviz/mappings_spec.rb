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

    context "rejecting omitted" do
      let(:args) { {omitted: true, unmapped: false} }

      it "returns expected mappings" do
        expect(result.length).to eq(203)
      end
    end

    context "rejecting unmapped" do
      let(:args) { {omitted: false, unmapped: true} }

      it "returns expected mappings" do
        expect(result.length).to eq(229)
      end
    end

    context "rejecting omitted and unmapped" do
      let(:args) { {omitted: true, unmapped: true} }

      it "returns expected mappings" do
        expect(result.length).to eq(193)
      end
    end
  end
end
