# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Year2025::Day06 do
  let(:input) { File.read(File.join(File.dirname(__FILE__), "../../../challenges/2025/06/input.txt")) }
  let(:example_input) {
    <<~EOF
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
    EOF
  }

  describe "part 1" do
    it "returns nil for the example input" do
      expect(described_class.part_1(example_input)).to eq(4277556)
    end

  end

  describe "part 2" do
    it "returns nil for the example input" do
      expect(described_class.part_2(example_input)).to eq(3263827)
    end
  end
end
