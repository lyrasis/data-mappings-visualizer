# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Mapviz" do
  describe ".worksheet" do
    it "returns Mapviz::Worksheet" do
      result = Mapviz.worksheet
      expect(result).to be_a(Mapviz::Worksheet)
    end
  end
end
