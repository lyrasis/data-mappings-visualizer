# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz::Node" do
  it "is Comparable as expected" do
    n1 = Mapviz::Node.new(id: "a", label: "foo", type: :orig)
    n2 = Mapviz::Node.new(id: "a", label: "foo", type: :orig)
    expect(n1).to eq(n2)
  end
end
