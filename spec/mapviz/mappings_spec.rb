# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Mappings" do
  subject(:mappings) { Mapviz::Mappings.new }

  it "delegates Array of Mapviz::Mapping Objects" do
    expect(mappings.length).to eq(239)
    expect(mappings.first).to be_a(Mapviz::Mapping)
  end
end
