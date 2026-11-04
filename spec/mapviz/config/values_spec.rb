# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Values" do
  subject(:mod) { Mapviz::Values }

  let(:mapping) { Mapviz::Mapping.new(row) }

  before(:all) do
    Mapviz::Headers.config.source = :source
    Mapviz::Headers.config.omission_reason = :omission_reason
    Mapviz::Headers.config.detail = :detail
  end
  after(:all) { Mapviz::Headers.reset_config }

  describe ".source" do
    let(:result) { mod.source.call(mapping) }

    context "when populated" do
      let(:row) { {source: "foo"} }

      it "returns expected value" do
        expect(result).to eq("foo")
      end
    end

    context "when unpopulated" do
      let(:row) { {source: nil} }

      it "returns expected value" do
        expect(result).to be_nil
      end
    end
  end

  describe ".omission_reason" do
    let(:result) { mod.omission_reason.call(mapping) }

    context "when populated" do
      let(:row) { {omission_reason: "foo"} }
      it "returns expected value" do
        expect(result).to eq("foo")
      end
    end

    context "when populated with placeholder" do
      let(:row) { {omission_reason: "."} }
      it "returns expected value" do
        expect(result).to be_nil
      end
    end

    context "when populated with empty string" do
      let(:row) { {omission_reason: ""} }
      it "returns expected value" do
        expect(result).to be_nil
      end
    end
  end

  describe ".detail" do
    let(:result) { mod.detail.call(mapping) }

    context "when populated" do
      let(:row) { {detail: "foo"} }
      it "returns expected value" do
        expect(result).to eq("foo")
      end

      context "when omission_reason also populated" do
        let(:row) { {detail: "foo", omission_reason: "bar"} }
        it "returns expected value" do
          expect(result).to eq("foo")
        end
      end
    end

    context "when populated with placeholder" do
      let(:row) { {detail: "."} }
      it "returns expected value" do
        expect(result).to be_nil
      end

      context "when omission_reason populated for real" do
        let(:row) { {detail: ".", omission_reason: "bar"} }
        it "returns expected value" do
          expect(result).to eq("bar")
        end
      end
    end

    context "when populated with empty string" do
      let(:row) { {detail: ""} }
      it "returns expected value" do
        expect(result).to be_nil
      end

      context "when omission_reason populated for real" do
        let(:row) { {detail: "", omission_reason: "bar"} }
        it "returns expected value" do
          expect(result).to eq("bar")
        end
      end
    end
  end
end
