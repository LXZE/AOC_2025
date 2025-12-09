# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Year2025::Day01 do
  let(:input) { File.read(File.join(File.dirname(__FILE__), "../../../challenges/2025/01/input.txt")) }
  let(:example_input) {
    <<~EOF
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
    EOF
  }

  let(:example_input_1) {
    <<~EOF
R50
L10
    EOF
  }

  describe "part 1" do
    it "returns nil for the example input" do
      expect(described_class.part_1(example_input)).to eq(3)
    end
  end

  describe "part 2" do
    it "returns nil for the example input" do
      expect(described_class.part_2(example_input)).to eq(6)
      expect(described_class.part_2(example_input_1)).to eq(1)
    end
  end
end
