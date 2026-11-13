# frozen_string_literal: true
module Year2025
  class Day02 < Solution
    def parse_range(line)
      from, to = line.split('-').map(&:to_i)
      Range.new(from, to)
    end

    def get_data
      data.split(',').map{parse_range _1}
    end

    def is_invalid?(number)
      str_num = number.to_s
      return false if str_num.size % 2 != 0
      mid = str_num.size / 2
      str_num[..(mid - 1)] == str_num[mid..]
    end

    def is_invalid2?(number)
      str_num = number.to_s
      /^(\d+)(\1)+$/.match?(str_num)
    end

    def part_1
      data = get_data
      data.flat_map{|range| range.select{is_invalid? _1}}.sum
    end

    def part_2
      data = get_data
      data.flat_map{|range| range.select{is_invalid2?  _1}}.sum
    end
  end
end
