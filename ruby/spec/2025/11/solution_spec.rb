# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Year2025::Day11 do
  let(:input) { File.read(File.join(File.dirname(__FILE__), "../../../challenges/2025/11/input.txt")) }
  let(:example_input) {
    <<~EOF
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
    EOF
  }

let(:example_input_p2) {
    <<~EOF
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
    EOF
  }

  describe "part 1" do
    it "returns nil for the example input" do
      expect(described_class.part_1(example_input)).to eq(5)
    end

  end

  describe "part 2" do
    it "returns nil for the example input" do
      expect(described_class.part_2(example_input_p2)).to eq(2)
    end

  end
end
