# frozen_string_literal: true
module Year2025
  class Day07 < Solution
    def get_split(num) [num-1, num+1] end

    def splitters_set
      data[2...].reject{_1.match? /^\.+$/}.map{ |line|
        line.chars.each_with_index.reject{_1[0] == "."}.map{_1[1]}.to_set
      }
    end

    def part_1
      start_pos = data[0].index('S')
      tachyon = Set[start_pos]

      res = 0
      splitters_set.each{|splitters|
        merged = splitters & tachyon
        remain = tachyon - merged
        tachyon = merged.map{get_split(_1).to_set}.reduce(&:merge) | remain

        res += merged.size
      }
      res
    end

    def part_2
      start_pos = data[0].index('S')
      tachyon = Set[start_pos]

      res = Hash.new(0)
      res[start_pos] = 1

      splitters_set.each{|splitters|
        merged = splitters & tachyon
        remain = tachyon - merged
        tachyon = merged.map{get_split(_1).to_set}.reduce(&:merge) | remain

        new_res = Hash.new(0)
        for t in remain do new_res[t] = res[t] end

        for t in merged
          l, r = get_split(t)
          new_res[l] += res[t]
          new_res[r] += res[t]
        end

        res = new_res
      }
      res.values.sum
    end

  end
end
