# frozen_string_literal: true
module Year2025
  class Day05 < Solution

    def get_data
      data.chunk(&:empty?).reject{_1[0]}.map{_1[1]}
    end

    def parse_range(range_str)
      a, b = range_str.split('-').map(&:to_i)
      Range.new(a, b)
    end

    def part_1
      ranges, ids = get_data
      ranges.map!{parse_range _1}

      ids.map(&:to_i).count { |id|
        ranges.any? {|range| range.include? id}
      }
    end

    def merge_range(a, b)
      Range.new([a.begin, b.begin].min, [a.last, b.last].max)
    end

    def loop_through_range(ranges)
      for i in 0...ranges.size
        for j in (i+1)...ranges.size
          if ranges[i].overlap?(ranges[j])
            b = ranges.delete_at(j)
            a = ranges.delete_at(i)
            ranges.push merge_range(a, b)
            return ranges
          end
        end
      end
    end

    def part_2
      ranges, _ids = get_data
      ranges.map!{parse_range _1}

      loop do
        new_ranges = loop_through_range(ranges.dup)
        break if new_ranges.size == ranges.size
        ranges = new_ranges
      end

      ranges.map(&:count).sum
    end
  end
end
