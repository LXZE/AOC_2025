# frozen_string_literal: true
module Year2025
  class Day12 < Solution

    def part_1
      *shape, regions = data.chunk{_1.empty?}.reject{_1[0]}.map{_1[1]}
      volumes = shape.map{_1[1..].join('').count('#')}
      regions.count{|reg|
        h, w, *req = reg.scan(/\d+/).map(&:to_i)
        # naive check, wtf
        (h*w) >= req.zip(volumes).map{_1*_2}.sum
      }
    end

    def part_2
      nil
    end

  end
end
