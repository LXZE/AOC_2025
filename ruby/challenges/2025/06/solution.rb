# frozen_string_literal: true
module Year2025
  class Day06 < Solution

    def parse
      data.map{|line|
        line.strip.gsub(/s+/, ' ').split(' ')
      }.transpose
    end
    
    def calc2(nums, op)
      case op
        when "+" then nums.sum
        when "*" then nums.reduce(:*)
      end
    end

    def calc(line)
      op = line.pop
      calc2(line.map(&:to_i), op)
    end

    def parse2
      res = data
      ops = res.pop
      [
        res.map(&:chars).transpose
          .chunk{_1.all? " "}
          .reject{_1[0]}.map{_1[1]}
          .map{|line| line.map{_1.join.to_i}},
        ops.strip.gsub(/s+/, ' ').split(' ')
      ]
    end

    def part_1
      parse.map{calc _1}.sum
    end

    def part_2
      parse2.then{|res, ops|
        res.zip(ops).map{calc2(_1, _2)}.sum
      }
    end
  end
end
