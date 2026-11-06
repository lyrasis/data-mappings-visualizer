# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::NodeAndEdgeMaker" do
  subject(:maker) { Mapviz::NodeAndEdgeMaker.new(mapping) }

  context "when orig to final target" do
    let(:mapping) do
      Mapviz::Mappings.new.find do |m|
        m.sourceField == "Accession Number" &&
          m.targetField == "numbervalue"
      end
    end
    let(:nodes) { maker.nodes }

    it "creates nodes" do
      expect(nodes.length).to eq(2)
    end

    it "creates expected source node" do
      result = nodes.first
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("accession_number")
      expect(result.label).to eq("Accession Number")
      expect(result.type).to eq(:orig)
    end

    it "creates expected target node" do
      result = nodes.last
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("object_numbervalue")
      expect(result.label).to eq("Object\nObject Identification Information "\
                                 "> Other number value")
      expect(result.type).to eq(:final)
    end
  end

  context "when orig, constrained, to intermediate target with detail" do
    let(:mapping) do
      Mapviz::Mappings.new.find do |m|
        m.sourceField == "Condition" &&
          m.conditions == 'is or starts with "good" and condassess blank'
      end
    end
    let(:nodes) { maker.nodes }

    it "creates nodes" do
      expect(nodes.length).to eq(4)
    end

    it "creates expected source node" do
      result = nodes.first
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("condition")
      expect(result.label).to eq("Condition")
      expect(result.type).to eq(:orig)
    end

    it "creates expected constraint node" do
      result = nodes[1]
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("condition_is_or_starts_with_good_and_"\
                              "condassess_blank")
      expect(result.label).to eq('is or starts with "good" and condassess '\
                                 "blank")
      expect(result.type).to eq(:constraint)
    end

    it "creates expected transform node" do
      result = nodes[2]
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("condassess_1_good")
      expect(result.label).to eq('"1 - good"')
      expect(result.type).to eq(:detail)
    end

    it "creates expected target node" do
      result = nodes.last
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("condassess")
      expect(result.label).to eq("condassess")
      expect(result.type).to eq(:intermediate)
    end
  end

  context "when omitted" do
    let(:mapping) do
      Mapviz::Mappings.new.find { |m| m.sourceField == "Catalogue Date" }
    end
    let(:nodes) { maker.nodes }

    it "creates nodes" do
      expect(nodes.length).to eq(3)
    end

    it "creates expected source node" do
      result = nodes.first
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("catalogue_date")
      expect(result.label).to eq("Catalogue Date")
      expect(result.type).to eq(:orig)
    end

    it "creates expected transform node" do
      result = nodes[1]
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("na_client_instruction")
      expect(result.label).to eq("client instruction")
      expect(result.type).to eq(:detail)
    end

    it "creates expected target node" do
      result = nodes.last
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("omitted")
      expect(result.label).to eq("Omitted from migration")
      expect(result.type).to eq(:omitted)
    end
  end

  context "when unmapped" do
    let(:mapping) do
      Mapviz::Mappings.new.find { |m| m.sourceField == "SKELETAL RECORD" }
    end
    let(:nodes) { maker.nodes }

    it "creates nodes" do
      expect(nodes.length).to eq(2)
    end

    it "creates expected source node" do
      result = nodes.first
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("skeletal_record")
      expect(result.label).to eq("SKELETAL RECORD")
      expect(result.type).to eq(:orig)
    end

    it "creates expected target node" do
      result = nodes.last
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("unmapped")
      expect(result.label).to eq("Not yet mapped")
      expect(result.type).to eq(:unmapped)
    end
  end

  context "when conditionally unmapped" do
    let(:mapping) do
      Mapviz::Mappings.new.find do |m|
        m.sourceField == "NEEDS CONSERVATION?" &&
          m.conditions == "value does not map to yes, no, or maybe"
      end
    end
    let(:nodes) { maker.nodes }

    it "creates nodes" do
      expect(nodes.length).to eq(3)
    end

    it "creates expected source node" do
      result = nodes.first
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("needs_conservation")
      expect(result.label).to eq("NEEDS CONSERVATION?")
      expect(result.type).to eq(:orig)
    end

    it "creates expected constraint node" do
      result = nodes[1]
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("needs_conservation_value_does_not_map_to_"\
                              "yes_no_or_maybe")
      expect(result.label).to eq("value does not map to yes, no, or maybe")
      expect(result.type).to eq(:constraint)
    end

    it "creates expected target node" do
      result = nodes.last
      expect(result).to be_a(Mapviz::Node)
      expect(result.id).to eq("unmapped")
      expect(result.label).to eq("Not yet mapped")
      expect(result.type).to eq(:unmapped)
    end
  end
end
