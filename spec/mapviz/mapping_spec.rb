# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Mapping" do
  subject(:mapping) { Mapviz::Mapping.new(row) }
  let(:row) { Mapviz.worksheet.rows.first }

  it "dynamically responds to row keys as methods" do
    expect(mapping.migrating).to eq("y")
    expect(mapping.status).to eq(".")
  end
end
