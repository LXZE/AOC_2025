# frozen_string_literal: true
module Year2025
  class Day11 < Solution

    def graph
      data.map{head, tail = _1.split(': '); [head, tail.split(' ')]}.to_h
    end

    def part_1
      map = graph
      currents = ["you"]
      total = 0
      while !currents.empty?
        new_currents = []
        for elem in currents
          map[elem].each{
            if _1 == "out"
              total += 1
            else
              new_currents.push(_1)
            end
          }
        end
        currents = new_currents
      end
      total
    end

    $cache = {}
    def traverse(current, map, target, state)
      $cache[[current, state]] ||= (
        if current == 'out' then state.size / 2 # only 2/2 => 1
        else
          map[current].map{
            new_state = if target.include? _1 then state | Set[_1] else state.clone end
            traverse(_1, map, target, new_state)
          }.sum
        end
      )
    end

    def part_2() traverse("svr", graph, Set["fft", "dac"], Set[]) end

  end
end
