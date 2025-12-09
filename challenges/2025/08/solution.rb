# frozen_string_literal: true
module Year2025
  class Day08 < Solution
    def distance(a, b)
      Integer.sqrt [b.x - a.x, b.y - a.y, b.z - a.z].map{_1.pow 2}.sum
    end

    Coord = Data.define(:x, :y, :z)
    def get_coords
      data.map{ x,y,z = _1.split(',').map(&:to_i); Coord.new(x, y, z) }
    end

    def get_init
      coords = get_coords
      circuits = coords.map{[_1, Set[_1]]}.to_h
      [coords, circuits]
    end

    def get_coords_dist(coords)
      coords.combination(2).map{ [_1, _2, distance(_1, _2)] }
        .sort_by{_1[2]}
    end

    def update_circuits(a, b, circuits)
      ca, cb = circuits[a], circuits[b]
      if ca != cb
        new_set = ca | cb
        for c in new_set do circuits[c] = new_set end
      end
    end

    def part_1
      limit = if ARGV.any?{_1.match? 'spec'} then 10 else 1000 end

      coords, circuits = get_init
      get_coords_dist(coords)[...limit].each{ update_circuits(_1, _2, circuits) }
      circuits.group_by{_2.__id__}.values.map{_1[0][1].size}.sort.reverse[...3].inject(:*)
    end

    def part_2
      coords, circuits = get_init
      get_coords_dist(coords).each{|a, b, _dist|
        update_circuits(a, b, circuits)
        if circuits.values.map{_1.__id__}.uniq.size == 1 then return a.x * b.x end
      }
    end

  end
end
