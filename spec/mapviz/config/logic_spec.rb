# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Logic" do
  subject(:mod) { Mapviz::Logic }

  before(:all) do
    Mapviz::Headers.config.detail = :detail
    Mapviz::Headers.config.included = :included
    Mapviz::Headers.config.source = :source
    Mapviz::Headers.config.omission_reason = :omission_reason
    Mapviz::Headers.config.target_field_machine = :target_field_machine
    Mapviz::Headers.config.target_field_user = :target_field_user
  end
  after(:all) { Mapviz::Headers.reset_config }

  let(:mapping) { Mapviz::Mapping.new(row) }

  describe ".is_migrating" do
    let(:result) { mod.is_migrating.call(mapping) }

    context "when included is y" do
      let(:row) { {included: "y"} }

      it "returns true" do
        expect(result).to be true
      end
    end

    context "when included is n" do
      let(:row) { {included: "n"} }

      it "returns falsey" do
        expect(result).to be_falsey
      end
    end

    context "when included is blank" do
      let(:row) { {included: ""} }

      it "returns falsey" do
        expect(result).to be_falsey
      end

      it "returns true with custom logic" do
        Mapviz::Logic.reset_config
        migproc = ->(row) do
          val = Mapviz::Values.included.call(mapping)
          return true if val.blank?

          true unless val.downcase == "n"
        end
        Mapviz::Logic.config.is_migrating = migproc
        expect(result).to be true
        Mapviz::Logic.reset_config
      end
    end
  end

  describe ".is_unmapped" do
    let(:result) { mod.is_unmapped.call(mapping) }

    context "when included is blank" do
      let(:row) { {included: ""} }

      it "returns true" do
        expect(result).to be true
      end
    end
  end
end
