# frozen_string_literal: true

require "spec_helper"

# All of these settings behave essentially identically. They just all need to
#   be set separately. Therefore, we are only going to test one.
RSpec.describe "Mapviz::Headers" do
  subject(:mod) { Mapviz::Headers }

  describe ".source" do
    let(:result) { mod.source }

    it "returns expected symbol when set as Symbol" do
      mod.config.source = :field
      expect(result).to eq(:field)
      mod.reset_config
    end

    it "returns expected symbol when set as String" do
      mod.config.source = "field"
      expect(result).to eq(:field)
      mod.reset_config
    end
  end
end
